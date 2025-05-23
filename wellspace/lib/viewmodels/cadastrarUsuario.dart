import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../models/Usuario.dart';
import '../services/UsuarioService.dart';

class CadastroViewModel {
  final formKey = GlobalKey<FormState>();
  String nome = '';
  String email = '';
  String senha = '';
  String confirmarSenha = '';
  DateTime dataNascimento = DateTime.now();
  XFile? fotoPerfil;

  String? validarSenhas() {
    if (senha != confirmarSenha) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  void _showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> cadastrarUsuario(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      String? senhaError = validarSenhas();
      if (senhaError != null) {
        _showSnackBar(context, senhaError, isError: true);
        return;
      }

      if (fotoPerfil == null) {
        _showSnackBar(context, 'Por favor, selecione uma foto de perfil.',
            isError: true);
        return;
      }

      try {
        bool success = await UsuarioService.cadastrarUsuarioComFoto(
          nome: nome,
          email: email,
          senha: senha,
          dataNascimento: dataNascimento,
          fotoPerfil: fotoPerfil!,
          integridade: false,
        );

        if (success) {
          _showSnackBar(context, 'Cadastro bem-sucedido!');
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          _showSnackBar(context, 'Erro no cadastro', isError: true);
        }
      } catch (e) {
        _showSnackBar(context, 'Erro ao se comunicar com o servidor',
            isError: true);
      }
    }
  }
}
