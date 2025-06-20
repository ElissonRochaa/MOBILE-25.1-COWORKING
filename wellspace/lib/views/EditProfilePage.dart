import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:Wellspace/viewmodels/UsuarioDetailViewModel.dart';
import 'package:Wellspace/models/Usuario.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _dataNascimentoController;
  late TextEditingController _senhaController;
  String? _fotoBase64;
  DateTime? _dataNascimentoSelecionada;

  @override
  void initState() {
    super.initState();
    final usuario =
        Provider.of<UsuarioDetailViewModel>(context, listen: false).usuario;

    _nomeController = TextEditingController(text: usuario?.nome ?? '');
    _emailController = TextEditingController(text: usuario?.email ?? '');
    _dataNascimentoSelecionada = usuario?.dataNascimento;
    _dataNascimentoController = TextEditingController(
      text: usuario?.dataNascimento != null
          ? "${usuario!.dataNascimento!.day.toString().padLeft(2, '0')}/${usuario.dataNascimento!.month.toString().padLeft(2, '0')}/${usuario.dataNascimento!.year}"
          : '',
    );
    _senhaController = TextEditingController();
    _fotoBase64 =
        usuario?.fotoPerfil.isNotEmpty == true ? usuario!.fotoPerfil : null;
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
      // ta faltando a logica de atualizar o back aqui

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<UsuarioDetailViewModel>(context).usuario;
    final theme = Theme.of(context);

    if (usuario == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Editar Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: theme.colorScheme.surfaceVariant,
                      backgroundImage: _fotoBase64 != null
                          ? NetworkImage(_fotoBase64!)
                          : null,
                      child: _fotoBase64 == null
                          ? Icon(Icons.person_outline,
                              size: 50,
                              color: theme.colorScheme.onSurfaceVariant)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _selecionarFoto,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primary.withOpacity(0.9),
                          ),
                          child: const Icon(Icons.edit,
                              color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
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
                readOnly: true,
                decoration:
                    const InputDecoration(labelText: "Data de nascimento"),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dataNascimentoSelecionada ?? DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _dataNascimentoSelecionada = picked;
                      _dataNascimentoController.text =
                          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                    });
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
