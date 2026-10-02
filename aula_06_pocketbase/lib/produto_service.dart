import 'package:pocketbase/pocketbase.dart';

class Produto {
  final String id;
  final String name;
  const Produto({required this.id, required this.name});

  factory Produto.fromJson(dynamic json) {
    if (json is! Map<String, dynamic> ||
        json['id'] is! String || json['name'] is! String) {
      throw const FormatException('Produto inválido');
    }
    return Produto(id: json['id'] as String, name: json['name'] as String);
  }
}

class ProdutoService {
  final PocketBase pb;
  ProdutoService(this.pb);

  Future<List<Produto>> listar() async {
    final records = await pb.collection('products').getFullList(sort: 'name');
    return records.map((r) => Produto.fromJson(r.toJson())).toList();
  }

  Future<Produto> criar(String name) async {
    final r = await pb.collection('products').create(
      body: {'name': _validarNome(name)},
    );
    return Produto.fromJson(r.toJson());
  }

  Future<Produto> atualizar(String id, String name) async {
    final r = await pb.collection('products').update(
      id, body: {'name': _validarNome(name)},
    );
    return Produto.fromJson(r.toJson());
  }

  Future<void> excluir(String id) async {
    await pb.collection('products').delete(id);
  }

  String _validarNome(String name) {
    final nome = name.trim();
    if (nome.isEmpty) throw ArgumentError('Digite um nome.');
    return nome;
  }
}
