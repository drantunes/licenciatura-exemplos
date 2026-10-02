import 'package:flutter/material.dart';

void main() => runApp(const CallbacksApp());

class CallbacksApp extends StatelessWidget {
  const CallbacksApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.teal),
    home: const CallbacksPage(),
  );
}

class CallbacksPage extends StatefulWidget {
  const CallbacksPage({super.key});
  @override
  State<CallbacksPage> createState() => _CallbacksPageState();
}

class _CallbacksPageState extends State<CallbacksPage> {
  final _nomes = <String>[];

  // Os dois botões chamam a mesma ação. O formulário vem na próxima etapa.
  void _adicionar() => setState(() => _nomes.add('Ana'));

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Callbacks')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Referência à função'),
          FilledButton(onPressed: _adicionar, child: const Text('Adicionar')),
          const SizedBox(height: 24),
          const Text('Função anônima'),
          FilledButton(
            onPressed: () {
              _adicionar();
            },
            child: const Text('Adicionar'),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(children: [for (final nome in _nomes) Text(nome)]),
          ),
        ],
      ),
    ),
  );
}
