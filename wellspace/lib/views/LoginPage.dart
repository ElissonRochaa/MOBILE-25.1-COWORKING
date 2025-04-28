import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/UsuarioService.dart';  // Certifique-se de que o caminho está correto
import '../config/JwtDecoder.dart';  // Importe o JwtDecoder corretamente

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _senha = '';
  bool _lembrarDeMim = false;
  bool _obscureText = true; // Controla a visibilidade da senha

  // Função de login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Exibe log de início de requisição
        print('Iniciando requisição de login...');
        
        // Requisição de login para o backend
        final response = await UsuarioService.login(_email, _senha);

        // Exibe a resposta bruta do servidor
        print('Resposta bruta do servidor: $response');
        
        // Verifica se a resposta contém o token
        if (response is String) {
          // Salva o token JWT
          String token = response;
          await UsuarioService.salvarToken(token);

          // Decodifica o token
          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          print('Decoded Token: $decodedToken');

          // Exibe uma mensagem de sucesso
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login bem-sucedido!')),
          );

          // Após o login bem-sucedido, você pode navegar para a próxima página
          Navigator.pushReplacementNamed(context, '/home'); // Ou qualquer outra página que você tenha configurado
        } else {
          // Caso o token não esteja presente na resposta
          print('Erro no login: Token não encontrado');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro no login: Token não encontrado')),
          );
        }
      } catch (e) {
        // Em caso de erro, exibe uma mensagem de erro
        print('Erro durante o login: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro no login')),
        );
      }
    } else {
      // Se o formulário não for válido
      print('Erro: Formulário inválido');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Text(
                'Entre com sua conta para acessar os detalhes dos espaços de coworking',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              // Campo de email
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu e-mail';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              const SizedBox(height: 16),
              // Campo de senha
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Muda o ícone conforme a visibilidade da senha
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText; // Alterna o estado de obscureText
                      });
                    },
                  ),
                ),
                obscureText: _obscureText, // Controla a visibilidade da senha
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira sua senha';
                  }
                  return null;
                },
                onSaved: (value) {
                  _senha = value!;
                },
              ),
              const SizedBox(height: 16),
              // Checkbox "Lembrar de mim"
              Row(
                children: [
                  Checkbox(
                    value: _lembrarDeMim,
                    onChanged: (value) {
                      setState(() {
                        _lembrarDeMim = value!;
                      });
                    },
                  ),
                  const Text('Lembrar de mim'),
                ],
              ),
              const SizedBox(height: 24),
              // Botão de login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  child: const Text('Entrar'),
                ),
              ),
              const SizedBox(height: 16),
              // Link para cadastro
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/cadastro');  // Navega para a página de cadastro
                },
                child: const Text(
                  'Não tem uma conta? Cadastre-se',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
