import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SalaImagemService {
  static const String _baseUrl = 'http://localhost:8080';
  static final _storage = FlutterSecureStorage();

  static Future<bool> cadastrarSalaImagemFromBytes({
    required String salaId,
    required Uint8List imagemBytes,
    required String fileName,
  }) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      final uri = Uri.parse('$_baseUrl/imagens/upload/$salaId');
      final request = http.MultipartRequest('POST', uri);

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.files.add(
        http.MultipartFile.fromBytes('imagem', imagemBytes, filename: fileName),
      );

      final response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Imagem cadastrada com sucesso!');
        return true;
      } else {
        final respStr = await response.stream.bytesToString();
        print('Erro ao cadastrar imagem: ${response.statusCode} - $respStr');
        return false;
      }
    } catch (e) {
      print('Erro ao cadastrar imagem: $e');
      return false;
    }
  }

  static Future<List<String>> listarImagensPorSala(String salaId) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      final uri = Uri.parse('$_baseUrl/imagens/sala/$salaId');
      final response = await http.get(
        uri,
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> lista = jsonDecode(response.body);
        return lista
            .map((item) => item['imagem'] as String?)
            .where((url) => url != null && url.isNotEmpty)
            .cast<String>()
            .toList();
      } else {
        print('Erro ao listar imagens: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Erro ao listar imagens: $e');
      return [];
    }
  }
}
