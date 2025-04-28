import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';  
import '../models/usuario.dart';  

class UsuarioService {

  static const String baseUrl = 'http://localhost:8080'; 


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


  static Future<void> salvarToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);  

  }
  static Future<String?> obterToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');  
}}
