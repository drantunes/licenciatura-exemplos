import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aula5_webservices/main.dart';
import 'package:aula5_webservices/produto_service.dart';

void main() {
  test('GET converte UTF-8 e id string', () async {
    final client = MockClient((r) async {
      expect(r.method, 'GET');
      expect(r.url.toString(), ProdutoService.base);
      return http.Response.bytes(utf8.encode('[{"id":"7","name":"Café"}]'), 200);
    });
    addTearDown(client.close);
    final itens = await ProdutoService(client).listar();
    expect(itens.single.name, 'Café');
    expect(itens.single.id, '7');
  });
  test('Erros HTTP, JSON e transporte são separados', () async {
    final badHttp = MockClient((r) async => http.Response('<html>falha</html>', 500));
    addTearDown(badHttp.close);
    await expectLater(ProdutoService(badHttp).listar(), throwsA(
      isA<ApiException>().having((e) => e.status, 'status', 500)));
    for (final body in ['{', '{}', '[{"id":1,"name":"A"}]']) {
      final client = MockClient((r) async => http.Response(body, 200));
      await expectLater(ProdutoService(client).listar(), throwsFormatException);
      client.close();
    }
    final offline = MockClient((r) async => throw http.ClientException('offline'));
    addTearDown(offline.close);
    await expectLater(ProdutoService(offline).listar(), throwsA(isA<http.ClientException>()));
  });
  testWidgets('Form valida; UI cria, edita e exclui com confirmação', (tester) async {
    final dados = <Map<String, String>>[];
    final verbos = <String>[];
    final client = MockClient((r) async {
      verbos.add(r.method);
      switch (r.method) {
        case 'GET': return http.Response(jsonEncode(dados), 200);
        case 'POST':
          expect(r.headers['content-type'], contains('application/json'));
          expect(jsonDecode(r.body), {'name': 'Dupla A - Caderno'});
          final p = {'id': '42', 'name': jsonDecode(r.body)['name'] as String};
          dados.add(p);
          return http.Response(jsonEncode(p), 201);
        case 'PUT':
          expect(r.url.path, '/products/42');
          dados.single['name'] = jsonDecode(r.body)['name'] as String;
          return http.Response(jsonEncode(dados.single), 200);
        case 'DELETE':
          expect(r.url.path, '/products/42');
          dados.clear();
          return http.Response('', 204);
        default: throw StateError('Método inesperado');
      }
    });
    addTearDown(client.close);
    await tester.pumpWidget(MaterialApp(home: ProdutosPage(client: client)));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum produto'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), '   ');
    await tester.tap(find.text('Criar'));
    await tester.pumpAndSettle();
    expect(find.text('Digite um nome'), findsOneWidget);
    expect(verbos, ['GET']);
    await tester.enterText(find.byType(TextFormField), ' Dupla A - Caderno ');
    await tester.tap(find.text('Criar'));
    await tester.pumpAndSettle();
    expect(find.text('Dupla A - Caderno'), findsOneWidget);
    await tester.tap(find.text('Dupla A - Caderno'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Dupla A - Caneta');
    await tester.tap(find.text('Salvar edição'));
    await tester.pumpAndSettle();
    expect(find.text('Dupla A - Caneta'), findsOneWidget);
    await tester.tap(find.byTooltip('Excluir Dupla A - Caneta'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(dados, hasLength(1));
    await tester.tap(find.byTooltip('Excluir Dupla A - Caneta'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum produto'), findsOneWidget);
    expect(verbos, ['GET', 'POST', 'GET', 'PUT', 'GET', 'DELETE', 'GET']);
  });
}
