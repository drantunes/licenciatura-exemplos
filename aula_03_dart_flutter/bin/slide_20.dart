// Exemplo da Aula 3, slide 20.
// ignore_for_file: avoid_print, unused_local_variable, dead_code, dead_null_aware_expression
String rotulo({required String titulo}) {
  return 'Tarefa: $titulo';
}

void main() {
  print(rotulo(titulo: 'Comprar pão'));
}
