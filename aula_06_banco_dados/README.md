# Aula 6 — Banco de Dados local

`SharedPreferencesAsync` persiste a preferência light/dark. `TemaController` lê o valor antes de runApp e expõe um ValueNotifier observado pelo MaterialApp. O catálogo usa Hive CE com Box<Map>, sem gerador de código, TypeAdapter ou anotações de modelo.

- `lib/main.dart`: inicialização e interface.
- `lib/tema_controller.dart`: tema e persistência da preferência.
- `lib/produto_service.dart`: mesmo modelo/contrato da Aula 5, com armazenamento local.
- `test/persistencia_test.dart`: tema, falha de escrita e CRUD após fechar/reabrir a box.

Packages: `flutter pub add shared_preferences hive_ce hive_ce_flutter`.

A [versão PocketBase](../aula_06_pocketbase) é uma alternativa de service. As duas versões não sincronizam seus catálogos.

## Executar e verificar

Execute `flutter pub get` e `flutter run `.

Para analisar e testar o código nesta pasta:

```sh
flutter pub get
flutter analyze
flutter test
```
