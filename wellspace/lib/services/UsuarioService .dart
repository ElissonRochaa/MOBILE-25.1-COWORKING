import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/usuario.dart';

class UsuarioService {
  static Future<bool> cadastrarUsuario(Usuario usuario) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/auth/cadastrar'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(usuario.toJson()),
      );

      // Verifica o status da resposta
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Erro no cadastro: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro: $e');
      return false;
    }
  }
}
