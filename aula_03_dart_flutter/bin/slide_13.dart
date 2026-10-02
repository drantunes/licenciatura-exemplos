// Exemplo da Aula 3, slide 13.
// ignore_for_file: avoid_print, unused_local_variable, dead_code, dead_null_aware_expression
void main() {
  String? observacao;

  print(observacao ?? 'Sem observação');

  observacao = 'Comprar até as 18h';
  print(observacao);

  // ? permite null; ?? oferece um padrão.
}
