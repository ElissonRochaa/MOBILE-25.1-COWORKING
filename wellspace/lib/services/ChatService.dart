import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static const String _baseUrl = 'https://wellspace-app.onrender.com/api';
  static final _storage = FlutterSecureStorage();

  Future<String> sendMessage(String text) async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      final response = await http.post(
        Uri.parse('$_baseUrl/chat'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'text': text}),
      );

      print('Resposta do backend: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reply'] ?? 'Resposta vazia.';
      } else {
        throw Exception(
            'Erro ao obter resposta: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erro ao enviar mensagem: $e');
      return 'Erro ao buscar resposta do servidor.';
    }
  }
}
