import 'package:flutter/material.dart';

import '../viewmodels/cadastrarUsuario.dart';

class CadastroPage extends StatelessWidget {
  final CadastroViewModel viewModel = CadastroViewModel();

  CadastroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: viewModel.formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
                onSaved: (value) {
                  viewModel.nome = value ?? '';
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu e-mail';
                  }
                  return null;
                },
                onSaved: (value) {
                  viewModel.email = value ?? '';
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma senha';
                  }
                  return null;
                },
                onSaved: (value) {
                  viewModel.senha = value ?? '';
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Confirmar Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirme sua senha';
                  }
                  return null;
                },
                onSaved: (value) {
                  viewModel.confirmarSenha = value ?? '';
                },
              ),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Data de Nascimento',
                ),
                keyboardType: TextInputType.datetime,
                onSaved: (value) {
                  viewModel.dataNascimento =
                      DateTime.tryParse(value ?? '') ?? DateTime.now();
                },
              ),

              ElevatedButton(
                onPressed: () {
                  viewModel.cadastrarUsuario(context);
                },
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
