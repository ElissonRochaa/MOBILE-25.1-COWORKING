import 'dart:convert';
import 'package:Wellspace/models/Reserva.dart'; //
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../services/UsuarioService.dart'; 

class ReservaService {
  static const String _baseUrl = 'https://wellspace-app.onrender.com';
  static final _storage = const FlutterSecureStorage();

  static Future<String> _getTokenOrThrow() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null || token.isEmpty) {
      throw Exception('Usuário não autenticado: token JWT ausente.');
    }
    return token;
  }

  static bool _isSuccess(int statusCode) =>
      statusCode >= 200 && statusCode < 300;

  static Future<List<Reserva>> buscarReservasPorLocatario(
      String usuarioId) async {
    try {
      final token = await _getTokenOrThrow();
      final response = await http.get(
        Uri.parse('$_baseUrl/api/reservas/locatario/$usuarioId'), 
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print(
          '[ReservaService] buscarReservasPorUsuario status: ${response.statusCode}');

      if (_isSuccess(response.statusCode)) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => Reserva.fromJson(json)).toList(); 
      } else {
        print(
            '[ReservaService] Erro ao buscar reservas por usuário: ${response.body}');
        return [];
      }
    } catch (e) {
      print('[ReservaService] Exceção em buscarReservasPorUsuario: $e');
      return [];
    }
  }

  static Future<Reserva?> criarReserva(ReservaRequest request) async { 
    try {
      final token = await _getTokenOrThrow();
      final response = await http.post(
        Uri.parse('$_baseUrl/reservas'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(request.toJson()), 
      );

      print('[ReservaService] criarReserva status: ${response.statusCode}');

      if (_isSuccess(response.statusCode)) {
        print('[ReservaService] Reserva criada com sucesso.');
        return Reserva.fromJson(json.decode(utf8.decode(response.bodyBytes))); //
      } else {
        print('[ReservaService] Erro ao criar reserva: ${response.body}');
        return null;
      }
    } catch (e) {
      print('[ReservaService] Exceção em criarReserva: $e');
      return null;
    }
  }

  static Future<bool> deletarReserva(String reservaId) async {
    try {
      final token = await _getTokenOrThrow();
      final response = await http.delete(
        Uri.parse('$_baseUrl/reservas/$reservaId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('[ReservaService] deletarReserva status: ${response.statusCode}');
      return _isSuccess(response.statusCode);
    } catch (e) {
      print('[ReservaService] Exceção em deletarReserva: $e');
      return false;
    }
  }

  static Future<List<Reserva>> listarReservasParaLocador(String locadorId) async {
    final token = await UsuarioService.obterToken(); 
    if (token == null) {
      throw Exception('Usuário não autenticado.');
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/reservas/locador/$locadorId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => Reserva.fromJson(json)).toList(); 
      } else {
        throw Exception('Falha ao carregar reservas recebidas.');
      }
    } catch (e) {
      print('Erro ao buscar reservas do locador: $e');
      rethrow;
    }
  }
}