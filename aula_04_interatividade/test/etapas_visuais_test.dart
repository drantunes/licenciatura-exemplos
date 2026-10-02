import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aula_04_interatividade/etapas/etapa_00_callbacks.dart';
import 'package:aula_04_interatividade/etapas/etapa_04_view_contagem.dart';

void main() {
  testWidgets('as duas formas de callback executam a mesma ação', (
    tester,
  ) async {
    await tester.pumpWidget(const CallbacksApp());
    final botoes = find.widgetWithText(FilledButton, 'Adicionar');
    await tester.tap(botoes.first);
    await tester.pump();
    expect(find.text('Ana'), findsOneWidget);
    await tester.tap(botoes.last);
    await tester.pump();
    expect(find.text('Ana'), findsNWidgets(2));
  });

  testWidgets('a View recebe o ViewModel e reconstrói somente a contagem', (
    tester,
  ) async {
    await tester.pumpWidget(const ContagemApp());
    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.text('Adicionar nome'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    expect(find.text('Ana'), findsNothing);
    await tester.tap(find.text('Adicionar nome'));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
  });
}
