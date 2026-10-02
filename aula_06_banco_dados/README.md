# Aula 6 — Banco de Dados local

[Slides](https://docs.google.com/presentation/d/1JetdY0mdSrBlJDo6uCxqJqhDnNMLDYP91tbZu8jah3I/edit)

`SharedPreferencesAsync` persiste a preferência light/dark. `TemaController` lê o valor antes de runApp e expõe um ValueNotifier observado pelo MaterialApp. O catálogo usa Hive CE com Box<Map>, sem gerador de código, TypeAdapter ou anotações de modelo.

- `lib/main.dart`: inicialização e interface.
- `lib/tema_controller.dart`: tema e persistência da preferência.
- `lib/produto_service.dart`: mesmo modelo/contrato da Aula 5, com armazenamento local.
- `test/persistencia_test.dart`: tema, falha de escrita e CRUD após fechar/reabrir a box.

Packages: `flutter pub add shared_preferences hive_ce hive_ce_flutter`.

A [versão PocketBase](../aula_06_pocketbase) é uma alternativa de service. As duas versões não sincronizam seus catálogos.

## Executar e verificar

A estrutura macOS está pronta. Execute `flutter pub get` e `flutter run -d macos`. A janela abre em 480 × 760 pontos. Para outras plataformas, gere a estrutura Flutter correspondente.

As [capturas reais da demonstração](../screenshots/aula_06/index.html) incluem o app reaberto com tema e produtos persistidos.

Para analisar e testar o código nesta pasta:

```sh
flutter pub get
flutter analyze
flutter test
```
