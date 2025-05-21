import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart'; 
import '../models/Usuario.dart';

class UsuarioService {
  static const String baseUrl = 'http://localhost:8080';
  static final _storage = const FlutterSecureStorage();

  // Cadastro de usuário
  static Future<bool> cadastrarUsuario(Usuario usuario) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/registrar'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(usuario.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Cadastro realizado com sucesso!');
        return true;
      } else {
        print('Erro no cadastro: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro ao fazer requisição: $e');
      return false;
    }
  }

  
  static Future<String> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Falha no login: ${response.body}');
    }
  }

  
  static Future<void> loginSalvarCredenciais(String email, String senha) async {
    final token = await login(email, senha);

    
    Map<String, dynamic> payload = Jwt.parseJwt(token);
    final usuarioId = payload['usuarioId'] as String?;

    if (usuarioId == null) {
      throw Exception('usuarioId não encontrado no token JWT');
    }

    await _storage.write(key: 'jwt_token', value: token);
    await _storage.write(key: 'usuario_id', value: usuarioId);

    print('Token e usuárioId salvos com sucesso.');
  }

 
  static Future<void> salvarToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  
  static Future<String?> obterToken() async => await _storage.read(key: 'jwt_token');

  
  static Future<String?> obterUsuarioId() async => await _storage.read(key: 'usuario_id');

 
  static Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'usuario_id');
  }
}
