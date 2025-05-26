import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import '../models/Usuario.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class UsuarioService {
  static const String baseUrl = 'http://localhost:8080';
  static final _storage = const FlutterSecureStorage();

  static Future<bool> cadastrarUsuarioComFoto({
    required String nome,
    required String email,
    required String senha,
    required DateTime dataNascimento,
    required XFile fotoPerfil,
    bool integridade = false,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/auth/registrar');
      var request = http.MultipartRequest('POST', uri);

      request.fields['nome'] = nome;
      request.fields['email'] = email;
      request.fields['senha'] = senha;
      String ano = dataNascimento.year.toString();
      String mes = dataNascimento.month.toString().padLeft(2, '0');
      String dia = dataNascimento.day.toString().padLeft(2, '0');
      request.fields['dataNascimento'] = '$ano-$mes-$dia';
      request.fields['integridade'] = integridade.toString();

      var bytes = await fotoPerfil.readAsBytes();

      var multipartFile = http.MultipartFile.fromBytes(
        'fotoPerfil',
        bytes,
        filename: fotoPerfil.name,
      );

      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Cadastro realizado com sucesso!');
        return true;
      } else {
        var respStr = await response.stream.bytesToString();
        print('Erro no cadastro: $respStr');
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

  static Future<String?> obterToken() async =>
      await _storage.read(key: 'jwt_token');

  static Future<String?> obterUsuarioId() async =>
      await _storage.read(key: 'usuario_id');

  static Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'usuario_id');
  }

  static Future<Usuario> buscarUsuarioPorId() async {
    final token = await obterToken();
    final usuarioId = await obterUsuarioId();

    if (token == null || usuarioId == null) {
      throw Exception(
          'Token ou usuárioId não encontrados. Faça login novamente.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/usuario/buscar/$usuarioId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return Usuario.fromJson(jsonBody);
    } else {
      throw Exception('Erro ao buscar usuário: ${response.body}');
    }
  }
/*
  static Future<bool> atualizarUsuarioComFoto({
    required String nome,
    required String email,
    required DateTime dataNascimento,
    XFile? novaFotoPerfil,
  }) async {
    final token = await obterToken();
    if (token == null) throw Exception('Token não encontrado');

    var uri = Uri.parse('$baseUrl/usuario/atualizar');
    var request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['usuarioUpdateRequest.nome'] = nome;
    request.fields['usuarioUpdateRequest.email'] = email;
    String dataFormatada =
        '${dataNascimento.year}-${dataNascimento.month.toString().padLeft(2, '0')}-${dataNascimento.day.toString().padLeft(2, '0')}';
    request.fields['usuarioUpdateRequest.dataNascimento'] = dataFormatada;

    if (novaFotoPerfil != null) {
      var fotoBytes = await novaFotoPerfil.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'fotoPerfil',
        fotoBytes,
        filename: novaFotoPerfil.name,
      ));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      var erro = await response.stream.bytesToString();
      print('Erro ao atualizar usuário: $erro');
      return false;
    }
  }*/
}
