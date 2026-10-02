import 'package:flutter/material.dart';

void main() => runApp(const Aula4App());

class Aula4App extends StatelessWidget {
  const Aula4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aula 4 — Nomes',
      theme: ThemeData(colorSchemeSeed: Colors.teal),
      home: const ListaPage(),
    );
  }
}

class ListaPage extends StatefulWidget {
  const ListaPage({super.key});

  @override
  State<ListaPage> createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  final _nomes = <String>[];
  bool _mostrarTotal = true;

  Future<void> _abrirFormulario() async {
    final nome = await Navigator.push<String>(
      context,
      MaterialPageRoute<String>(builder: (context) => const NomePage()),
    );
    if (!mounted || nome == null) return;
    setState(() => _nomes.add(nome));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de nomes')),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Mostrar total'),
            value: _mostrarTotal,
            onChanged: (valor) {
              setState(() => _mostrarTotal = valor);
            },
          ),
          if (_mostrarTotal)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Total: ${_nomes.length}'),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _nomes.length,
              itemBuilder: (context, index) =>
                  ListTile(title: Text(_nomes[index])),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              onPressed: _abrirFormulario,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar nome'),
            ),
          ),
        ],
      ),
    );
  }
}

class NomePage extends StatefulWidget {
  const NomePage({super.key});

  @override
  State<NomePage> createState() => _NomePageState();
}

class _NomePageState extends State<NomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  String? _validarNome(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Digite um nome';
    }
    return null;
  }

  void _adicionar() {
    if (!_formKey.currentState!.validate()) return;
    final nome = _nomeController.text.trim();
    Navigator.pop(context, nome);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar nome')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: _validarNome,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _adicionar(),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _adicionar,
                child: const Text('Adicionar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
