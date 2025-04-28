import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/UsuarioService.dart'; 

class CadastroViewModel {
  final formKey = GlobalKey<FormState>();
  String nome = '';
  String email = '';
  String senha = '';
  String confirmarSenha = '';
  DateTime dataNascimento = DateTime.now();
  String fotoPerfil = '';

  // Função para validar se as senhas coincidem
  String? validarSenhas() {
    if (senha != confirmarSenha) {
      return 'As senhas não coincidem';
    }
    return null;
  }


  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // Método de cadastro de usuário
  Future<void> cadastrarUsuario(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      // Valida se as senhas coincidem
      String? senhaError = validarSenhas();
      if (senhaError != null) {
        _showSnackBar(context, senhaError, isError: true);
        return;
      }

      // Cria o usuário a partir dos dados preenchidos, com 'integridade' setado como false
      Usuario usuario = Usuario(
        nome: nome,
        email: email,
        senha: senha,  // A senha já foi validada, então sem o campo confirmarSenha
        dataNascimento: dataNascimento,
        fotoPerfil: fotoPerfil,
        integridade: false, // Setando integridade como false
      );

      try {
        // Chama o serviço para cadastrar o usuário
        bool success = await UsuarioService.cadastrarUsuario(usuario);

        // Exibe a mensagem de sucesso ou erro conforme o resultado
        if (success) {
          _showSnackBar(context, 'Cadastro bem-sucedido!');
        } else {
          _showSnackBar(context, 'Erro no cadastro', isError: true);
        }
      } catch (e) {
        // Exibe erro genérico se ocorrer uma falha no serviço
        _showSnackBar(context, 'Erro ao se comunicar com o servidor', isError: true);
      }
    }
  }
}
