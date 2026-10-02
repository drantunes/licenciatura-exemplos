import 'package:flutter/material.dart';

import '../main.dart' show Tarefa;

void main() => runApp(const MeuApp());

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: TelaTarefas());
  }
}

// Aula 3, “Uma função constrói cada linha”. O próximo slide inclui o ícone.
class TelaTarefas extends StatelessWidget {
  const TelaTarefas({super.key});
  @override
  Widget build(BuildContext context) {
    const tarefas = <Tarefa>[
      Tarefa(titulo: 'Comprar pão'),
      Tarefa(titulo: 'Estudar Dart', concluida: true),
      Tarefa(titulo: 'Beber água'),
    ];
    return Scaffold(
      appBar: AppBar(title: Text('Minhas tarefas (${tarefas.length})')),
      body: ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          final tarefa = tarefas[index];
          return ListTile(title: Text(tarefa.titulo));
        },
      ),
    );
  }
}
