import 'dart:convert';

import 'package:Wellspace/models/Usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioService {
  static Future<bool> cadastrarUsuario(Usuario usuario) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/auth/cadastrar'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(usuario.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erro: $e');
      return false;
    }
  }
}
