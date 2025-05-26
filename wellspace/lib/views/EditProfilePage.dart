import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EdiProfilePage extends StatefulWidget {
  const EdiProfilePage({super.key});

  @override
  State<EdiProfilePage> createState() => _EdiProfilePageState();
}

class _EdiProfilePageState extends State<EdiProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _dataNascimentoController;
  late TextEditingController _senhaController;
  String? _fotoBase64;

  @override
  void initState() {
    super.initState();

    // MOCKED USER DATA
    _nomeController = TextEditingController(text: "João Silva");
    _emailController = TextEditingController(text: "joao@email.com");
    _dataNascimentoController = TextEditingController(text: "01/01/1990");
    _senhaController = TextEditingController();
    _fotoBase64 = null;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _dataNascimentoController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _selecionarFoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _fotoBase64 = "data:image/png;base64,${base64Encode(bytes)}";
      });
    }
  }

  void _salvarPerfil() {
    if (_formKey.currentState!.validate()) {
      // Simula o salvamento e mostra um snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Perfil (mockado) atualizado com sucesso!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _selecionarFoto,
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage:
                      _fotoBase64 != null ? NetworkImage(_fotoBase64!) : null,
                  child: _fotoBase64 == null
                      ? const Icon(Icons.person, size: 45)
                      : null,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome completo"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Informe seu nome" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Informe seu email" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dataNascimentoController,
                decoration:
                    const InputDecoration(labelText: "Data de nascimento"),
                readOnly: true,
                onTap: () async {
                  final initialDate = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    _dataNascimentoController.text =
                        "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _senhaController,
                decoration:
                    const InputDecoration(labelText: "Nova senha (opcional)"),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _salvarPerfil,
                child: const Text("Salvar alterações"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
