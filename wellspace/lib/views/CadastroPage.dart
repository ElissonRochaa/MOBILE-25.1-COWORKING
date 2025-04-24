import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Adicione este pacote no pubspec.yaml
import '../viewmodels/cadastrarUsuario.dart';

class CadastroPage extends StatelessWidget {
  final CadastroViewModel viewModel = CadastroViewModel();

  CadastroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: viewModel.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Criar Conta',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Preencha os campos abaixo para se cadastrar',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 24),

                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Nome Completo',
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Por favor, insira seu nome'
                                  : null,
                      onSaved: (value) => viewModel.nome = value ?? '',
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Por favor, insira seu e-mail'
                                  : null,
                      onSaved: (value) => viewModel.email = value ?? '',
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Senha',
                        suffixIcon: Icon(Icons.visibility),
                      ),
                      obscureText: true,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Por favor, insira uma senha'
                                  : null,
                      onSaved: (value) => viewModel.senha = value ?? '',
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline),
                        labelText: 'Confirmar Senha',
                        suffixIcon: Icon(Icons.visibility),
                      ),
                      obscureText: true,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Por favor, confirme sua senha'
                                  : null,
                      onSaved:
                          (value) => viewModel.confirmarSenha = value ?? '',
                    ),
                    const SizedBox(height: 16),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          viewModel.cadastrarUsuario(context);
                        },
                        child: const Text('Cadastrar'),
                      ),
                    ),

                    const SizedBox(height: 24),
                    const Text("OU CONTINUE COM"),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton.icon(
                          icon: const FaIcon(FontAwesomeIcons.google, size: 18),
                          label: const Text("Google"),
                          onPressed: () {},
                        ),
                        OutlinedButton.icon(
                          icon: const FaIcon(
                            FontAwesomeIcons.facebook,
                            size: 18,
                          ),
                          label: const Text("Facebook"),
                          onPressed: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        // Navegar para login
                      },
                      child: const Text(
                        'Já tem uma conta? Faça login',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
