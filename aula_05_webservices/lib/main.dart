import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'produto_service.dart';

void main() => runApp(const MaterialApp(home: ProdutosPage()));

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key, this.client});
  final http.Client? client; // Nos testes, o chamador é dono do cliente.
  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  late final http.Client _client;
  late final ProdutoService service;
  late Future<List<Produto>> produtosFuture;
  final nome = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool salvando = false;
  Produto? selecionado;

  @override
  void initState() {
    super.initState();
    _client = widget.client ?? http.Client();
    service = ProdutoService(_client);
    produtosFuture = service.listar();
  }

  @override
  void dispose() {
    nome.dispose();
    if (widget.client == null) _client.close();
    super.dispose();
  }

  void recarregar() {
    setState(() => produtosFuture = service.listar());
  }

  String mensagem(Object erro) {
    if (erro is TimeoutException) {
      return 'Tempo esgotado. Confira a lista antes de reenviar.';
    }
    if (erro is http.ClientException) return 'Não foi possível conectar.';
    if (erro is FormatException) return 'A API retornou dados inesperados.';
    if (erro is ApiException) {
      if (erro.status == 404) return 'Produto não encontrado. Atualize a lista.';
      if (erro.status == 401) return 'Autenticação necessária.';
      if (erro.status == 403) return 'Ação não permitida.';
      return 'A API recusou a operação (HTTP ${erro.status}).';
    }
    return 'Não foi possível concluir. Tente novamente.';
  }

  Future<void> executar(Future<void> Function() acao) async {
    if (salvando) return;
    setState(() => salvando = true);
    try {
      await acao();
      if (!mounted) return;
      nome.clear();
      setState(() {
        selecionado = null;
        produtosFuture = service.listar();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Operação concluída.')),
      );
    } catch (erro) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagem(erro))),
      );
    } finally {
      if (mounted) setState(() => salvando = false);
    }
  }

  Future<void> salvar() async {
    if (!formKey.currentState!.validate()) return;
    final produto = selecionado;
    final valor = nome.text.trim();
    await executar(() async {
      if (produto == null) {
        await service.criar(valor);
      } else {
        await service.atualizar(produto.id, valor);
      }
    });
  }

  Future<void> confirmarExclusao(Produto p) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir produto?'),
        content: Text('${p.name} — id ${p.id}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir')),
        ],
      ),
    );
    if (!mounted || confirmado != true) return;
    await executar(() => service.excluir(p.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos · Aula 5'), actions: [
        IconButton(onPressed: salvando ? null : recarregar,
          tooltip: 'Atualizar lista', icon: const Icon(Icons.refresh)),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Form(key: formKey, child: TextFormField(
            controller: nome, enabled: !salvando,
            decoration: const InputDecoration(labelText: 'Nome do produto'),
            validator: (v) => v == null || v.trim().isEmpty ? 'Digite um nome' : null,
          )),
          Row(children: [
            FilledButton(onPressed: salvando ? null : salvar,
              child: Text(selecionado == null ? 'Criar' : 'Salvar edição')),
            if (selecionado != null) TextButton(
              onPressed: salvando ? null : () {
                nome.clear();
                setState(() => selecionado = null);
              }, child: const Text('Cancelar edição')),
          ]),
          if (salvando) const LinearProgressIndicator(),
          Expanded(child: FutureBuilder<List<Produto>>(
            future: produtosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(mensagem(snapshot.error!)),
                  TextButton(onPressed: salvando ? null : recarregar,
                    child: const Text('Tentar novamente')),
                ]));
              }
              final produtos = snapshot.data ?? <Produto>[];
              if (produtos.isEmpty) return const Center(child: Text('Nenhum produto'));
              return ListView.builder(
                itemCount: produtos.length,
                itemBuilder: (context, i) {
                  final p = produtos[i];
                  return ListTile(title: Text(p.name), subtitle: Text('id ${p.id}'),
                    onTap: salvando ? null : () {
                      nome.text = p.name;
                      setState(() => selecionado = p);
                    },
                    trailing: IconButton(tooltip: 'Excluir ${p.name}',
                      onPressed: salvando ? null : () => confirmarExclusao(p),
                      icon: const Icon(Icons.delete_outline)),
                  );
                },
              );
            },
          )),
        ]),
      ),
    );
  }
}
