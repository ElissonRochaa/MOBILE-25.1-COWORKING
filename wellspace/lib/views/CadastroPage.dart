import 'package:flutter/material.dart';

import '../viewmodels/cadastrarUsuario.dart';

class CadastroPage extends StatelessWidget {
  final CadastroViewModel viewModel = CadastroViewModel();

  CadastroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Criar Conta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: viewModel.formKey,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  viewModel.cadastrarUsuario(context);
                },
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
