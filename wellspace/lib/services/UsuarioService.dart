import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import '../models/Usuario.dart';
import 'package:image_picker/image_picker.dart';

class UsuarioService {
  static const String baseUrl = 'http://localhost:8080'; 
  static final _storage = const FlutterSecureStorage();
  static const Duration _timeoutDuration = Duration(seconds: 15);

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

      var streamedResponse = await request.send().timeout(_timeoutDuration);
      var responseString = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
        return true;
      } else {
        throw Exception('Erro no cadastro (status ${streamedResponse.statusCode}): $responseString');
      }
    } on TimeoutException catch (_) {
      throw Exception('Tempo de requisição esgotado ao tentar cadastrar usuário.');
    } on http.ClientException catch (e) {
      throw Exception('Erro de conexão ao tentar cadastrar usuário: ${e.message}');
    } catch (e) {
      if (e.toString().contains('Erro no cadastro (status') ||
          e.toString().contains('Tempo de requisição esgotado') ||
          e.toString().contains('Erro de conexão')) {
        rethrow;
      }
      throw Exception('Erro desconhecido ao fazer requisição de cadastro: $e');
    }
  }

  static Future<String> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({'email': email, 'senha': senha}),
      ).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Falha no login (status ${response.statusCode}): ${response.body}');
      }
    } on TimeoutException catch (_) {
      throw Exception('Tempo de requisição esgotado ao tentar fazer login.');
    } on http.ClientException catch (e) {
      throw Exception('Erro de conexão ao tentar fazer login: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> loginSalvarCredenciais(String email, String senha) async {
    try {
      final token = await login(email, senha);
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      final usuarioId = payload['usuarioId']?.toString();

      if (usuarioId == null || usuarioId.isEmpty) {
        throw Exception('usuarioId não encontrado ou inválido no token JWT');
      }

      await _storage.write(key: 'jwt_token', value: token);
      await _storage.write(key: 'usuario_id', value: usuarioId);
    } catch (e) {
      rethrow;
    }
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
      throw Exception('Token ou usuárioId não encontrados. Faça login novamente.');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/usuario/buscar/$usuarioId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final jsonBody = json.decode(utf8.decode(response.bodyBytes));
        return Usuario.fromJson(jsonBody);
      } else {
        throw Exception('Erro ao buscar usuário (status ${response.statusCode}): ${response.body}');
      }
    } on TimeoutException catch (_) {
      throw Exception('Tempo de requisição esgotado ao buscar dados do usuário.');
    } on http.ClientException catch (e) {
      throw Exception('Erro de conexão ao buscar dados do usuário: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> requestPasswordReset(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({'email': email}),
      ).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Falha ao solicitar redefinição de senha (status ${response.statusCode}): ${response.body}');
      }
    } on TimeoutException catch (_) {
      throw Exception('Tempo de requisição esgotado ao solicitar redefinição de senha.');
    } on http.ClientException catch (e) {
      throw Exception('Erro de conexão ao solicitar redefinição de senha: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> submitNewPassword(String token, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({'token': token, 'newPassword': newPassword}),
      ).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Falha ao redefinir senha (status ${response.statusCode}): ${response.body}');
      }
    } on TimeoutException catch (_) {
      throw Exception('Tempo de requisição esgotado ao tentar redefinir a senha.');
    } on http.ClientException catch (e) {
      throw Exception('Erro de conexão ao tentar redefinir a senha: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> atualizarUsuarioComFoto({
    required String nome,
    required String email,
    required DateTime dataNascimento,
    XFile? novaFotoPerfil,
  }) async {
    final token = await obterToken();
    if (token == null) {
      throw Exception('Token não encontrado para atualizar usuário. Faça login novamente.');
    }

    try {
      var uri = Uri.parse('${UsuarioService.baseUrl}/usuario/atualizar');
      var request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['nome'] = nome;
      request.fields['email'] = email;
      String dataFormatada =
          '${dataNascimento.year}-${dataNascimento.month.toString().padLeft(2, '0')}-${dataNascimento.day.toString().padLeft(2, '0')}';
      request.fields['dataNascimento'] = dataFormatada;

      if (novaFotoPerfil != null) {
        var fotoBytes = await novaFotoPerfil.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'fotoPerfil',
          fotoBytes,
          filename: novaFotoPerfil.name,
        ));
      }

      var streamedResponse = await request.send().timeout(UsuarioService._timeoutDuration);
      var responseString = await streamedResponse.stream.bytesToString();
      
      if (streamedResponse.statusCode == 200) {
        return true;
      } else {
        throw Exception('Erro ao atualizar usuário (status ${streamedResponse.statusCode}): $responseString');
      }
    } on TimeoutException catch (_) {
      throw Exception('Tempo de requisição esgotado ao tentar atualizar usuário.');
    } on http.ClientException catch (e) {
      throw Exception('Erro de conexão ao tentar atualizar usuário: ${e.message}');
    } catch (e) {
      if (e.toString().contains('Erro ao atualizar usuário (status') ||
          e.toString().contains('Tempo de requisição esgotado') ||
          e.toString().contains('Erro de conexão')) {
        rethrow;
      }
      throw Exception('Erro desconhecido ao tentar atualizar usuário: $e');
    }
  }
}