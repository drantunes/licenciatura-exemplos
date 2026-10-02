// Exemplo da Aula 3, slide 18.
// ignore_for_file: avoid_print, unused_local_variable, dead_code, dead_null_aware_expression
void main() {
  final tarefas = ['Comprar pão', 'Beber água'];

  for (final titulo in tarefas) {
    print('Pendente: $titulo');
  }

  // Uma execução do bloco por elemento.
}
