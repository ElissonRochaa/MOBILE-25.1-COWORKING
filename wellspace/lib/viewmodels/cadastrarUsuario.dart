import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../services/UsuarioService .dart';

class CadastroViewModel {
  final formKey = GlobalKey<FormState>();
  String nome = '';
  String email = '';
  String senha = '';
  String confirmarSenha = '';
  DateTime dataNascimento = DateTime.now();
  String fotoPerfil = '';

  void cadastrarUsuario(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      Usuario usuario = Usuario(
        nome: nome,
        email: email,
        senha: senha,
        confirmarSenha: confirmarSenha,
        dataNascimento: dataNascimento,
        fotoPerfil: fotoPerfil,
      );

      bool success = await UsuarioService.cadastrarUsuario(usuario);

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Cadastro bem-sucedido!')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro no cadastro')));
      }
    }
  }
}
