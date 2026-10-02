import 'package:hive_ce/hive_ce.dart';

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
  final Box<Map> box;
  ProdutoService(this.box);

  Future<List<Produto>> listar() async {
    return box.keys.map((key) {
      final dados = Map<String, dynamic>.from(box.get(key)!);
      return Produto.fromJson({...dados, 'id': key.toString()});
    }).toList();
  }

  Future<Produto> criar(String name) async {
    final nome = _validarNome(name);
    final key = await box.add({'name': nome});
    return Produto(id: key.toString(), name: nome);
  }

  Future<Produto> atualizar(String id, String name) async {
    final key = _chaveExistente(id);
    final nome = _validarNome(name);
    await box.put(key, {'name': nome});
    return Produto(id: id, name: nome);
  }

  Future<void> excluir(String id) async {
    final key = _chaveExistente(id);
    await box.delete(key);
  }

  int _chaveExistente(String id) {
    final key = int.tryParse(id);
    if (key == null || !box.containsKey(key)) {
      throw StateError('Produto não encontrado. Atualize a lista.');
    }
    return key;
  }

  String _validarNome(String name) {
    final nome = name.trim();
    if (nome.isEmpty) throw ArgumentError('Digite um nome.');
    return nome;
  }
}
