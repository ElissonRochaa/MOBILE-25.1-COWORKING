import 'package:Wellspace/services/UsuarioService%20.dart';
import 'package:flutter/material.dart';

import '../models/usuario.dart';

class CadastroViewModel {
  final formKey = GlobalKey<FormState>();
  String nome = '';
  String email = '';
  String senha = '';
  String confirmarSenha = '';
  DateTime dataNascimento = DateTime.now();
  String fotoPerfil = '';

  // Método de cadastro de usuário
  void cadastrarUsuario(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      // Verifica se as senhas são iguais antes de tentar o cadastro
      if (senha != confirmarSenha) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('As senhas não coincidem')),
        );
        return;
      }

      // Cria o usuário a partir dos dados preenchidos
      Usuario usuario = Usuario(
        nome: nome,
        email: email,
        senha: senha,
        confirmarSenha: confirmarSenha,
        dataNascimento: dataNascimento,
        fotoPerfil: fotoPerfil,
      );

      // Chama o serviço para cadastrar o usuário
      bool success = await UsuarioService.cadastrarUsuario(usuario);

      // Exibe a mensagem de sucesso ou erro conforme o resultado
      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Cadastro bem-sucedido!')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Erro no cadastro')));
      }
    }
  }
}
