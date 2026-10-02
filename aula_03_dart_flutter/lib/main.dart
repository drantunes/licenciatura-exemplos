import 'package:flutter/material.dart';

void main() => runApp(const MeuApp());

class Tarefa {
  final String titulo;
  final bool concluida;
  const Tarefa({required this.titulo, this.concluida = false});
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: TelaTarefas());
  }
}

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
          return ListTile(
            leading: Icon(
              tarefa.concluida
                  ? Icons.check_circle_outline
                  : Icons.radio_button_unchecked,
            ),
            title: Text(tarefa.titulo),
          );
        },
      ),
    );
  }
}
