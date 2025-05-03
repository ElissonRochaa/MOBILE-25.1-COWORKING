
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Sala.dart';

class SalaService {
  static const String _baseUrl = 'http://localhost:8080';

 
  static Future<bool> cadastrarSala(Sala sala) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/salas/criar-sala'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(sala.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Sala cadastrada com sucesso!');
        return true;
      } else {
        print('Erro ao cadastrar sala: ${response.statusCode} – ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro: $e');
      return false;
    }
  }
}
