import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aula_07_recursos_nativos/main.dart';

void main() {
  testWidgets('inicialização libera as três ações sem imagem pendente', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RecursosPage()));
    await tester.pumpAndSettle();
    expect(find.text('Tirar foto'), findsOneWidget);
    expect(find.text('Galeria'), findsOneWidget);
    expect(find.text('Ler QR Code'), findsOneWidget);
    expect(find.text('Nenhum QR Code lido.'), findsOneWidget);
    for (final button in tester.widgetList<FilledButton>(
      find.byType(FilledButton),
    )) {
      expect(button.onPressed, isNotNull);
    }
    expect(find.byType(LinearProgressIndicator), findsNothing);
  });
}
