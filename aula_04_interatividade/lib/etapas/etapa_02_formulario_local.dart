import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.teal),
    home: const NomePage(),
  ),
);

class NomePage extends StatefulWidget {
  const NomePage({super.key});

  @override
  State<NomePage> createState() => _NomePageState();
}

class _NomePageState extends State<NomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _nomes = <String>[];

  String? _validarNome(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Digite um nome';
    }
    return null;
  }

  void _adicionar() {
    if (!_formKey.currentState!.validate()) return;
    final nome = _nomeController.text.trim();
    setState(() => _nomes.add(nome));
    _nomeController.clear();
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
              const SizedBox(height: 24),
              for (final nome in _nomes) Text(nome),
            ],
          ),
        ),
      ),
    );
  }
}
