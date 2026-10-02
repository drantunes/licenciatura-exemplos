import 'package:flutter/material.dart';

import '../main.dart' show NomesViewModel;

void main() => runApp(const ContagemApp());

class ContagemApp extends StatelessWidget {
  const ContagemApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.teal),
    home: const ContagemPage(),
  );
}

class ContagemPage extends StatefulWidget {
  const ContagemPage({super.key});
  @override
  State<ContagemPage> createState() => _ContagemPageState();
}

class _ContagemPageState extends State<ContagemPage> {
  final _viewModel = NomesViewModel();
  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Contagem de nomes')),
    body: Column(
      children: [
        Expanded(
          child: Center(child: NomesView(viewModel: _viewModel)),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: () => _viewModel.adicionar('Ana'),
            child: const Text('Adicionar nome'),
          ),
        ),
      ],
    ),
  );
}

// Aula 4, “A View recebe a dependência”: mostra somente o número, não a lista.
class NomesView extends StatelessWidget {
  const NomesView({super.key, required this.viewModel});
  final NomesViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Text('${viewModel.nomes.length}');
      },
    );
  }
}
