import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/UsuarioService.dart';  
import '../config/JwtDecoder.dart';  

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
  bool _obscureText = true; 
  // Função de login
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
       
        print('Iniciando requisição de login...');
    
        final response = await UsuarioService.login(_email, _senha);

       
        print('Resposta bruta do servidor: $response');
        
        
        if (response is String) {
   
          String token = response;
          await UsuarioService.salvarToken(token);

        
          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          print('Decoded Token: $decodedToken');

        
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login bem-sucedido!')),
          );

        
          Navigator.pushReplacementNamed(context, '/home');
        } else {
        
          print('Erro no login: Token não encontrado');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro no login: Token não encontrado')),
          );
        }
      } catch (e) {
       
        print('Erro durante o login: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro no login')),
        );
      }
    } else {
     
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
             
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                     
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                obscureText: _obscureText, 
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
             
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  child: const Text('Entrar'),
                ),
              ),
              const SizedBox(height: 16),
            
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/cadastro');  
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
