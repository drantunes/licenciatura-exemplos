import 'dart:convert';
import 'package:http/http.dart' as http;

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

class ApiException implements Exception {
  final int status;
  const ApiException(this.status);
}

class ProdutoService {
  final http.Client client;
  ProdutoService(this.client);
  static const base = 'https://62d205d2dccad0cf17705a26.mockapi.io/products';
  static const limite = Duration(seconds: 10);
  static const headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=UTF-8',
  };

  void conferir(http.Response r, Set<int> esperados) {
    if (!esperados.contains(r.statusCode)) {
      throw ApiException(r.statusCode);
    }
  }

  dynamic lerJson(http.Response r) => jsonDecode(utf8.decode(r.bodyBytes));

  Future<List<Produto>> listar() async {
    final r = await client.get(Uri.parse(base), headers: headers).timeout(limite);
    conferir(r, {200});
    final dados = lerJson(r);
    if (dados is! List) throw const FormatException('Lista inválida');
    return dados.map(Produto.fromJson).toList();
  }

  Future<Produto> criar(String name) async {
    final r = await client.post(
      Uri.parse(base), headers: headers,
      body: jsonEncode({'name': name.trim()}),
    ).timeout(limite);
    conferir(r, {201});
    return Produto.fromJson(lerJson(r));
  }

  Future<Produto> atualizar(String id, String name) async {
    final r = await client.put(
      Uri.parse('$base/${Uri.encodeComponent(id)}'),
      headers: headers,
      body: jsonEncode({'name': name.trim()}),
    ).timeout(limite);
    conferir(r, {200});
    return Produto.fromJson(lerJson(r));
  }

  Future<void> excluir(String id) async {
    final r = await client.delete(
      Uri.parse('$base/${Uri.encodeComponent(id)}'),
      headers: headers,
    ).timeout(limite);
    conferir(r, {200, 204});
    // 204 não tem corpo. A exclusão não precisa decodificar JSON.
  }
}
