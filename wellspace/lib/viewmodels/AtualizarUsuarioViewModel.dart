/*

aqui é necessario uma conversa sobre como fazer essa mudança no perfil, como vamos armazerar os outros itens :
profissão, bibliografia e etc

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/Usuario.dart';
import '../services/UsuarioService.dart';

class AtualizarUsuarioViewModel with ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  String? usuarioId;
  String nome = '';
  String email = '';
  DateTime dataNascimento = DateTime.now();
  XFile? novaFotoPerfil;

  bool _carregando = false;
  bool get carregando => _carregando;

  void setCarregando(bool value) {
    _carregando = value;
    notifyListeners();
  }

  void preencherCampos(Usuario usuario) {
    nome = usuario.nome;
    email = usuario.email;
    dataNascimento = usuario.dataNascimento!;
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

  Future<void> atualizarUsuario(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (usuarioId == null) {
        _showSnackBar(context, 'ID do usuário não encontrado.', isError: true);
        return;
      }

      try {
        setCarregando(true);
        bool sucesso = await UsuarioService.atualizarUsuarioComFoto(
          nome: nome,
          email: email,
          dataNascimento: dataNascimento,
          novaFotoPerfil: novaFotoPerfil,
        );

        setCarregando(false);
        if (sucesso) {
          _showSnackBar(context, 'Usuário atualizado com sucesso!');
          Navigator.pop(context);
        } else {
          _showSnackBar(context, 'Erro ao atualizar usuário.', isError: true);
        }
      } catch (e) {
        setCarregando(false);
        _showSnackBar(context, 'Erro ao se comunicar com o servidor.',
            isError: true);
      }
    }
  }
*/
