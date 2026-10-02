// Exemplo da Aula 3, slide 15.
// ignore_for_file: avoid_print, unused_local_variable, dead_code, dead_null_aware_expression
void main() {
  var total = 2;
  final limite = 3;
  total = total + 1;
  print('Total: $total');
  print(total == limite);
}

// E se tentarmos limite = 4?
