import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/Sala.dart';
import '../models/Favorito.dart';

class SalaService {
  static const String _baseUrl = 'https://wellspace-app.onrender.com';
  static final _storage = const FlutterSecureStorage();

  static Future<String> _getTokenOrThrow() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null || token.isEmpty) {
      throw Exception('Usuário não autenticado: token JWT ausente.');
    }
    print('[SalaService] Token JWT obtido.');
    return token;
  }

  static bool _isSuccess(int statusCode) =>
      statusCode == 200 || statusCode == 201 || statusCode == 204;

  static Future<Sala?> cadastrarSala(Sala sala) async {
    try {
      final token = await _getTokenOrThrow();

      final response = await http.post(
        Uri.parse('$_baseUrl/salas/criar-sala'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(sala.toJson()),
      );

      print('[SalaService] cadastrarSala status: ${response.statusCode}');

      if (_isSuccess(response.statusCode)) {
        print('[SalaService] Sala cadastrada com sucesso.');
        return Sala.fromJson(json.decode(response.body));
      } else {
        print(
            '[SalaService] Erro ao cadastrar sala: ${response.statusCode} – ${response.body}');
        return null;
      }
    } catch (e) {
      print('[SalaService] Exceção ao cadastrar sala: $e');
      return null;
    }
  }

  static Future<List<Sala>> listarSalas() async {
    try {
      final token = await _getTokenOrThrow();

      final response = await http.get(
        Uri.parse('$_baseUrl/salas/listar-salas'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('[SalaService] listarSalas status: ${response.statusCode}');

      if (_isSuccess(response.statusCode)) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Sala.fromJson(json)).toList(); //
      } else {
        print('[SalaService] Erro ao listar salas: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('[SalaService] Exceção ao listar salas: $e');
      return [];
    }
  }

  static Future<Sala?> buscarSalaPorId(String id) async {
    try {
      final token = await _getTokenOrThrow();

      final response = await http.get(
        Uri.parse('$_baseUrl/salas/buscar-sala/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print(
          '[SalaService] buscarSalaPorId status: ${response.statusCode} for ID $id');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          print('[SalaService] Sala encontrada com sucesso.');
          return Sala.fromJson(json.decode(response.body)); //
        } else {
          print(
              '[SalaService] Sala encontrada (200), mas corpo da resposta vazio.');
          return null;
        }
      } else if (response.statusCode == 404) {
        print(
            '[SalaService] Sala com ID $id não encontrada: ${response.statusCode}');
        return null;
      } else {
        print(
            '[SalaService] Erro ao buscar sala por ID $id: ${response.statusCode} – ${response.body}');
        return null;
      }
    } catch (e) {
      print('[SalaService] Exceção ao buscar sala por ID $id: $e');
      return null;
    }
  }

  static Future<bool> deletarSala(String id) async {
    try {
      final token = await _getTokenOrThrow();

      final response = await http.delete(
        Uri.parse('$_baseUrl/salas/deletar-sala/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('[SalaService] deletarSala status: ${response.statusCode}');

      return _isSuccess(response.statusCode);
    } catch (e) {
      print('[SalaService] Exceção ao deletar sala: $e');
      return false;
    }
  }

  static Future<bool> alterarDisponibilidade(
      String id, String novaDisponibilidade) async {
    try {
      final token = await _getTokenOrThrow();

      final response = await http.put(
        Uri.parse('$_baseUrl/salas/alterar-disponibilidade/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(novaDisponibilidade),
      );

      print(
          '[SalaService] alterarDisponibilidade status: ${response.statusCode}');

      return _isSuccess(response.statusCode);
    } catch (e) {
      print('[SalaService] Exceção ao alterar disponibilidade: $e');
      return false;
    }
  }

  static Future<List<Sala>> listarSalasPorUsuarioId(String usuarioId) async {
    try {
      final token = await _getTokenOrThrow();

      final response = await http.get(
        Uri.parse('$_baseUrl/salas/usuario/$usuarioId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (_isSuccess(response.statusCode)) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => Sala.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<bool> favoritarSala(String usuarioId, String salaId) async {
    try {
      final token = await _getTokenOrThrow();

      final body = json.encode({
        "usuarioId": usuarioId,
        "salaId": salaId,
      });

      final response = await http.post(
        Uri.parse('$_baseUrl/favoritos/criar-favorito'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      print('[SalaService] favoritarSala status: ${response.statusCode}');
      return _isSuccess(response.statusCode);
    } catch (e) {
      print('[SalaService] Exceção ao favoritar sala: $e');
      return false;
    }
  }

  static Future<List<Favorito>> listarFavoritosPorUsuario(
      String usuarioId) async {
    try {
      final token = await _getTokenOrThrow();

      final response = await http.get(
        Uri.parse('$_baseUrl/favoritos/listar-por-usuario/$usuarioId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print(
          '[SalaService] listarFavoritosPorUsuario status: ${response.statusCode}');

      if (_isSuccess(response.statusCode)) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => Favorito.fromJson(json)).toList();
      } else {
        print('[SalaService] Erro ao listar favoritos: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('[SalaService] Exceção ao listar favoritos: $e');
      return [];
    }
  }

  static Future<bool> deletarFavorito(String favoritoId) async {
    try {
      final token = await _getTokenOrThrow();

      final response = await http.delete(
        Uri.parse('$_baseUrl/favoritos/deletar/$favoritoId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('[SalaService] deletarFavorito status: ${response.statusCode}');
      return _isSuccess(response.statusCode);
    } catch (e) {
      print('[SalaService] Exceção ao deletar favorito: $e');
      return false;
    }
  }
}
