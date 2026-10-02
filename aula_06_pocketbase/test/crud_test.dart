import 'package:flutter_test/flutter_test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:aula6_pocketbase/produto_service.dart';

void main() {
  test('CRUD real na instância isolada de PocketBase', () async {
    final service = ProdutoService(PocketBase('http://127.0.0.1:18096'));
    final p = await service.criar('  Café de teste  ');
    try {
      expect(p.name, 'Café de teste');
      expect(p.id, isNotEmpty);
      expect((await service.listar()).any((item) => item.id == p.id), isTrue);
      await service.atualizar(p.id, 'Caderno de teste');
      final outroCliente = ProdutoService(PocketBase('http://127.0.0.1:18096'));
      expect((await outroCliente.listar()).singleWhere((e) => e.id == p.id).name,
        'Caderno de teste');
    } finally {
      await service.excluir(p.id);
    }
    expect((await service.listar()).any((item) => item.id == p.id), isFalse);
    await expectLater(service.criar('  '), throwsArgumentError);
  });
}
