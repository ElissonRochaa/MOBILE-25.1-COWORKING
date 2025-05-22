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
    // Verifica se salaId não é nulo ou vazio antes de fazer a chamada
    if (salaId.isEmpty) {
      print('Erro: ID da sala está vazio. Não é possível listar imagens.');
      return [];
    }

    try {
      final token = await _storage.read(key: 'jwt_token');
      final uri = Uri.parse('$_baseUrl/imagens/sala/$salaId');

      print(
          'Listando imagens para Sala ID: $salaId, URI: $uri'); // Log para depuração

      final response = await http.get(
        uri,
        headers: {
          'Content-Type':
              'application/json', // Adicionado para clareza, embora GET não tenha corpo
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      );

      print(
          'Resposta do serviço de listar imagens: Status ${response.statusCode}, Corpo: ${response.body}'); // Log detalhado

      if (response.statusCode == 200) {
        // Verifica se o corpo da resposta não está vazio antes de decodificar
        if (response.body.isEmpty) {
          print('Corpo da resposta vazio ao listar imagens.');
          return [];
        }

        final List<dynamic> listaJson = jsonDecode(response.body);

        // Se a listaJson estiver vazia, retorna lista vazia.
        if (listaJson.isEmpty) {
          print('Nenhuma imagem encontrada para a sala $salaId.');
          return [];
        }

        // Assumindo que cada item na lista é um Map e contém a chave 'imagemUrl'
        // conforme a estrutura JSON que você compartilhou anteriormente:
        // [ { "id": "...", "imagemUrl": "..." }, ... ]
        // Se a chave for diferente (ex: "imagem"), ajuste abaixo.
        return listaJson
            .map((item) {
              if (item is Map<String, dynamic> &&
                  item.containsKey('imagemUrl')) {
                return item['imagemUrl'] as String?;
              }
              print('Item inválido ou sem chave "imagemUrl": $item');
              return null; // Retorna null para itens que não correspondem ao formato esperado
            })
            .where((url) =>
                url != null && url.isNotEmpty) // Filtra URLs nulas ou vazias
            .cast<String>() // Garante que a lista final é List<String>
            .toList();
      } else {
        print(
            'Erro ao listar imagens: ${response.statusCode} - ${response.body}');
        return []; // Retorna lista vazia em caso de erro
      }
    } catch (e, stackTrace) {
      print('Exceção ao listar imagens: $e');
      print('Stack Trace da exceção: $stackTrace');
      return []; // Retorna lista vazia em caso de exceção
    }
  }
}
