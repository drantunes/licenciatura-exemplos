# Aula 6 — Banco de Dados remoto com PocketBase

Mesmo catálogo e contrato de ProdutoService da [versão Hive CE](../aula_06_banco_dados), usando a coleção `products` no servidor. O tema permanece local com SharedPreferencesAsync e ValueNotifier. Não há sincronização automática com Hive CE.

Packages: `flutter pub add shared_preferences pocketbase`. A pasta inclui lib, dependências, estrutura macOS, migration de demonstração e teste. Para outras plataformas, gere a estrutura Flutter correspondente.

Em ambiente não Android, com o servidor iniciado, execute `flutter pub get` e `flutter run --dart-define=PB_URL=http://127.0.0.1:8090`. 
## Servidor PocketBase da demonstração

1. Baixe o executável oficial em https://pocketbase.io/docs/ e execute `./pocketbase serve` numa pasta dedicada.
2. Configure o superusuário administrativo pelo painel, sem colocar suas credenciais no aplicativo.
3. Crie a coleção Base `products` com campo Text `name`, obrigatório. O id é gerado pelo servidor.
4. Apenas na instância isolada de demonstração, desbloqueie List, View, Create, Update e Delete em API Rules, deixando a expressão vazia. Isso torna o CRUD público; não use essa configuração para dados reais ou num servidor exposto à internet.
5. Alternativamente, copie `backend/pb_migrations` para a pasta do servidor antes de iniciá-lo: a migration cria a coleção e as regras da demo.

Emulador Android:

```sh
flutter run --dart-define=PB_URL=http://10.0.2.2:8090
```

Para desktop ou simulador que acesse o loopback do computador, o padrão do exemplo é `http://127.0.0.1:8090`. No dispositivo físico, informe o IP alcançável do servidor. Nesse caso, configure a interface de escuta e restrinja o acesso à rede do laboratório. Em servidor publicado, use HTTPS e regras de autorização adequadas.

Android precisa de `<uses-permission android:name="android.permission.INTERNET" />` dentro de manifest, fora de application, no manifesto principal. 
## Verificar

```sh
flutter pub get
flutter analyze
```

O teste de CRUD usa um servidor real isolado em `http://127.0.0.1:18096`. Numa pasta dedicada, disponibilize o executável PocketBase e a migration da demonstração, depois inicie:

```sh
./pocketbase serve --http=127.0.0.1:18096
```

Com o servidor iniciado, execute `flutter test` nesta pasta. O teste cria um registro fictício, consulta, edita, verifica por outro cliente e remove o próprio registro. 

