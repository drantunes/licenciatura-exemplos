import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aula6_banco_dados/produto_service.dart';
import 'package:aula6_banco_dados/tema_controller.dart';

class PreferenciasFake extends Fake implements SharedPreferencesAsync {
  final dados = <String, dynamic>{};
  String? get valor => dados['valor'] as String?;
  set valor(String? v) => dados['valor'] = v;
  bool get falhar => dados['falhar'] == true;
  set falhar(bool v) => dados['falhar'] = v;
  @override
  Future<String?> getString(String key) async => valor;
  @override
  Future<void> setString(String key, String value) async {
    if (falhar) throw StateError('Falha de escrita');
    valor = value;
  }
}
void main() {
  test('tema carrega dark antes da UI e mantém valor se a escrita falha', () async {
    final prefs = PreferenciasFake()..valor = 'dark';
    final c = TemaController(prefs);
    await c.carregar();
    expect(c.tema.value, ThemeMode.dark);
    await c.alternar();
    expect(prefs.valor, 'light');
    expect(c.tema.value, ThemeMode.light);
    prefs.falhar = true;
    await expectLater(c.alternar(), throwsStateError);
    expect(c.tema.value, ThemeMode.light);
    c.dispose();
  });
  test('tema ausente usa light', () async {
    final c = TemaController(PreferenciasFake());
    await c.carregar();
    expect(c.tema.value, ThemeMode.light);
    c.dispose();
  });
  test('Hive persiste CRUD após fechar e reabrir a box', () async {
    final dir = await Directory.systemTemp.createTemp('aula6_hive_');
    final hive = Hive..init(dir.path);
    try {
      var box = await hive.openBox<Map>('produtos');
      var service = ProdutoService(box);
      final p = await service.criar('  Café  ');
      expect(p.name, 'Café');
      await box.close();
      box = await hive.openBox<Map>('produtos');
      service = ProdutoService(box);
      expect((await service.listar()).single.id, p.id);
      await service.atualizar(p.id, 'Caderno');
      await box.close();
      box = await hive.openBox<Map>('produtos');
      service = ProdutoService(box);
      expect((await service.listar()).single.name, 'Caderno');
      await service.excluir(p.id);
      await box.close();
      box = await hive.openBox<Map>('produtos');
      service = ProdutoService(box);
      expect(await service.listar(), isEmpty);
      await expectLater(service.atualizar(p.id, 'Ausente'), throwsStateError);
      await expectLater(service.criar('  '), throwsArgumentError);
    } finally {
      await hive.close();
      await dir.delete(recursive: true);
    }
  });
}
