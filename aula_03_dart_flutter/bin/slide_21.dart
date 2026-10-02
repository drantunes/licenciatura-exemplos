// Exemplo da Aula 3, slide 21.
// ignore_for_file: avoid_print, unused_local_variable, dead_code, dead_null_aware_expression
class Tarefa {
  final String titulo;
  final bool concluida;

  const Tarefa({required this.titulo, this.concluida = false});
}

void main() {
  const tarefa = Tarefa(titulo: 'Comprar pão');
  print(tarefa.titulo);
}
