// Exemplo da Aula 3, slide 11.
// ignore_for_file: avoid_print, unused_local_variable, dead_code, dead_null_aware_expression
void main() {
  final inicio = DateTime.now();
  const curso = 'Flutter';

  final tarefas = ['Comprar pão'];
  tarefas.add('Estudar Dart'); // permitido

  // tarefas = []; // não pode reatribuir
  // const fixa também o conteúdo da lista.
}
