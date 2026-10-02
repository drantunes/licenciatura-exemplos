# Códigos de Exemplos

Demonstrações Flutter das Aulas 3–7 do Prof. Dr. Diego Antunes. Cada pasta de aula é um projeto independente. Os exemplos preservam os textos, os dados e os conceitos apresentados nos slides do professor.

| Projeto | Demonstração |
| --- | --- |
| `aula_03_dart_flutter` | Objetos `Tarefa`, `ListView.builder`, total e ícone condicional |
| `aula_04_interatividade` | Formulário de nomes, validação, rotas, estado local e ViewModel |
| `aula_05_webservices` | CRUD de produtos via HTTP e mockAPI |
| `aula_06_banco_dados` | Tema com SharedPreferences/ValueNotifier e produtos no Hive CE |
| `aula_06_pocketbase` | Mesmo catálogo de produtos com service PocketBase |
| `aula_07_recursos_nativos` | Foto, galeria e QR Code com UI chamando service |

## Demo Android da Aula 7

O projeto `aula_07_recursos_nativos` inclui estrutura Android pronta, APK de debug gerado e instruções de execução no seu README. O macOS suporta seleção de arquivos e QR Code, mas image_picker não oferece captura de foto por padrão no desktop.

## Executar

Requer Flutter SDK e a configuração da plataforma alvo (Android, Web, iOS, Android, MacOS). Ambiente usado: Flutter 3.47.2 / Dart 3.13.2.
Por exemplo:

```sh
cd aula_03_dart_flutter # ou outra pasta
flutter pub get
flutter run 
```
