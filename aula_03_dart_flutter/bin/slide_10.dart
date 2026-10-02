// Exemplo da Aula 3, slide 10.
// ignore_for_file: avoid_print, unused_local_variable, dead_code, dead_null_aware_expression
void main() {
  var titulo = 'Comprar pão';
  titulo = 'Comprar frutas';

  print(titulo);

  // titulo = 42;
  // Erro: titulo foi inferido como String.
}
