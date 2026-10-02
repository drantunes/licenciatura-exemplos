import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aula_04_interatividade/main.dart';
import 'package:aula_04_interatividade/etapas/etapa_02_formulario_local.dart'
    as local;
import 'package:aula_04_interatividade/etapas/etapa_03_navegacao.dart' as navegacao;

void main() {
  test('ViewModel rejeita espaços, normaliza e notifica somente mudanças', () {
    final vm = NomesViewModel();
    addTearDown(vm.dispose);
    var avisos = 0;
    vm.addListener(() => avisos++);
    vm.adicionar('');
    vm.adicionar('   ');
    expect(vm.nomes, isEmpty);
    expect(avisos, 0);
    vm.adicionar(' Ana ');
    expect(vm.nomes, ['Ana']);
    expect(avisos, 1);
    expect(() => vm.nomes.add('Bia'), throwsUnsupportedError);
  });

  testWidgets(
    'formulário, retorno, cancelamento e preferência preservam nomes',
    (tester) async {
      await tester.pumpWidget(const Aula4App());
      expect(find.text('Total: 0'), findsOneWidget);
      await tester.tap(find.text('Adicionar nome'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Adicionar'));
      await tester.pumpAndSettle();
      expect(find.text('Digite um nome'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), '   ');
      await tester.tap(find.text('Adicionar'));
      await tester.pumpAndSettle();
      expect(find.text('Digite um nome'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), ' Ana ');
      await tester.tap(find.text('Adicionar'));
      await tester.pumpAndSettle();
      expect(find.text('Ana'), findsOneWidget);
      expect(find.text('Total: 1'), findsOneWidget);
      await tester.tap(find.text('Mostrar total'));
      await tester.pumpAndSettle();
      expect(find.text('Total: 1'), findsNothing);
      expect(find.text('Ana'), findsOneWidget);
      await tester.tap(find.text('Adicionar nome'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField))
            .controller!
            .text,
        isEmpty,
      );
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('Ana'), findsOneWidget);
      await tester.tap(find.text('Mostrar total'));
      await tester.pumpAndSettle();
      expect(find.text('Total: 1'), findsOneWidget);
    },
  );

  testWidgets('etapa local limpa o campo após adicionar', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: local.NomePage()));
    await tester.enterText(find.byType(TextFormField), ' Ana ');
    await tester.tap(find.text('Adicionar'));
    await tester.pumpAndSettle();
    expect(find.text('Ana'), findsOneWidget);
    expect(
      tester.widget<TextFormField>(find.byType(TextFormField)).controller!.text,
      isEmpty,
    );
  });

  testWidgets('etapa de navegação devolve o nome à lista local', (
    tester,
  ) async {
    await tester.pumpWidget(const navegacao.Aula4App());
    await tester.tap(find.text('Adicionar nome'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), ' Ana ');
    await tester.tap(find.text('Adicionar'));
    await tester.pumpAndSettle();
    expect(find.text('Ana'), findsOneWidget);
    expect(find.text('Total: 1'), findsOneWidget);
  });
}
