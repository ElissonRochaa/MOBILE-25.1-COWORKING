import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../viewmodels/cadastrarUsuario.dart';

class CadastroPage extends StatefulWidget {
  final CadastroViewModel viewModel = CadastroViewModel();

  CadastroPage({super.key});

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  bool _obscureTextSenha = true;
  bool _obscureTextConfirmarSenha = true;
  late TextEditingController _dataNascimentoController;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _dataNascimentoController = TextEditingController(
      text: widget.viewModel.dataNascimento.toLocal().toString().split(' ')[0],
    );
  }

  @override
  void dispose() {
    _dataNascimentoController.dispose();
    super.dispose();
  }

  Future<void> _getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        widget.viewModel.fotoPerfil = image;
        _imageBytes = bytes;
      });
    }
  }

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
                key: widget.viewModel.formKey,
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
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Por favor, insira seu nome' : null,
                      onSaved: (value) => widget.viewModel.nome = value ?? '',
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Por favor, insira seu e-mail' : null,
                      onSaved: (value) => widget.viewModel.email = value ?? '',
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: 'Senha',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextSenha ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureTextSenha = !_obscureTextSenha;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureTextSenha,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Por favor, insira uma senha' : null,
                      onSaved: (value) => widget.viewModel.senha = value ?? '',
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        labelText: 'Confirmar Senha',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextConfirmarSenha ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureTextConfirmarSenha = !_obscureTextConfirmarSenha;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureTextConfirmarSenha,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Por favor, confirme sua senha'
                          : null,
                      onSaved: (value) => widget.viewModel.confirmarSenha = value ?? '',
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _dataNascimentoController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        labelText: 'Data de Nascimento',
                        hintText: 'AAAA-MM-DD',
                      ),
                      readOnly: true,
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: widget.viewModel.dataNascimento,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            widget.viewModel.dataNascimento = selectedDate;
                            _dataNascimentoController.text =
                                selectedDate.toLocal().toString().split(' ')[0];
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua data de nascimento';
                        }
                        try {
                          DateTime.parse(value);
                        } catch (e) {
                          return 'Data inválida. Use o formato YYYY-MM-DD';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty) {
                          widget.viewModel.dataNascimento = DateTime.parse(value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: _getImage,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: _imageBytes == null
                            ? const Icon(Icons.camera_alt, color: Colors.white)
                            : ClipOval(
                                child: Image.memory(
                                  _imageBytes!,
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.viewModel.cadastrarUsuario(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
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
                          icon: const FaIcon(FontAwesomeIcons.facebook, size: 18),
                          label: const Text("Facebook"),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {},
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
