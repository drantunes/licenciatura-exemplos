// Exemplo da Aula 3, slide 19.
// ignore_for_file: avoid_print, unused_local_variable, dead_code, dead_null_aware_expression
String status(bool concluida) {
  if (concluida) return 'Concluída';
  return 'Pendente';
}

void main() {
  print(status(false));
  print(status(true));
}
