import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tema_controller.dart';
import 'produto_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final temaController = TemaController(SharedPreferencesAsync());
  try {
    await temaController.carregar();
    await Hive.initFlutter();
    final box = await Hive.openBox<Map>('produtos');
    runApp(ProdutosApp(
      service: ProdutoService(box), temaController: temaController,
    ));
  } catch (_) {
    runApp(const MaterialApp(home: Scaffold(
      body: Center(child: Text('Falha ao abrir os dados. Reabra o app.')),
    )));
  }
}

class ProdutosApp extends StatelessWidget {
  final ProdutoService service;
  final TemaController temaController;
  const ProdutosApp({super.key, required this.service, required this.temaController});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
    valueListenable: temaController.tema,
    builder: (context, modo, child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), darkTheme: ThemeData.dark(),
      themeMode: modo,
      home: ProdutosPage(service: service, temaController: temaController),
    ),
  );
}

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key, required this.service, required this.temaController});
  final ProdutoService service;
  final TemaController temaController;
  @override
  State<ProdutosPage> createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  late final ProdutoService service;
  late Future<List<Produto>> produtosFuture;
  final nome = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool salvando = false;
  Produto? selecionado;

  @override
  void initState() {
    super.initState();
    service = widget.service;
    produtosFuture = service.listar();
  }

  @override
  void dispose() {
    nome.dispose();
    super.dispose();
  }

  void recarregar() {
    setState(() => produtosFuture = service.listar());
  }

  String mensagem(Object erro) {
    if (erro is StateError) return erro.message;
    if (erro is ArgumentError) return 'Digite um nome válido.';
    if (erro is FormatException) return 'Registro local inválido.';
    return 'Não foi possível salvar ou ler os dados locais.';
  }

  Future<void> alternarTema() async {
    try {
      await widget.temaController.alternar();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível salvar o tema.')),
      );
    }
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
      appBar: AppBar(title: const Text('Produtos · Aula 6'), actions: [
        IconButton(onPressed: alternarTema, tooltip: 'Alternar tema',
          icon: const Icon(Icons.brightness_6)),
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
