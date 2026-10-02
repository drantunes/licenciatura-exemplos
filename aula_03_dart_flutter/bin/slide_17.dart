// Exemplo da Aula 3, slide 17.
// ignore_for_file: avoid_print, unused_local_variable, dead_code, dead_null_aware_expression
void main() {
  final tarefas = <String>['Comprar pão'];

  tarefas.add('Estudar Dart');
  tarefas.remove('Comprar pão');

  print(tarefas); // [Estudar Dart]
  print(tarefas.length); // 1
}
