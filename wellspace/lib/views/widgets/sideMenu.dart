import 'package:flutter/material.dart';
import 'package:Wellspace/models/Usuario.dart';
import 'package:Wellspace/services/UsuarioService.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  Usuario? _usuario;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final usuario = await UsuarioService.buscarUsuarioPorId();
      setState(() {
        _usuario = usuario;
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar dados do usuário para o SideMenu: $e');
      setState(() {
        _errorMessage = "Erro ao carregar dados.";
        _isLoading = false;
      });
    }
  }

  Widget _buildDrawerHeaderContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
            SizedBox(height: 10),
            Text("Carregando...", style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    }

    if (_errorMessage != null || _usuario == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30,
            child: Icon(Icons.error_outline, color: Colors.red, size: 30),
          ),
          const SizedBox(height: 10),
          Text(
            _errorMessage ?? 'Usuário não encontrado',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 30,
          backgroundImage: _usuario!.fotoPerfil.isNotEmpty
              ? NetworkImage(_usuario!.fotoPerfil)
              : null,
          child: _usuario!.fotoPerfil.isEmpty
              ? const Icon(Icons.person, color: Colors.blue, size: 30)
              : null,
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/Perfil');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _usuario!.nome,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Text(
                'Ver perfil',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _buildDrawerHeaderContent(),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Explorar Espaços'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/espacos');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Minhas Reservas'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.pushReplacementNamed(context, '/minhasReservas');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_business),
            title: const Text('Cadastrar Sala'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/cadastroSala');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Meu Perfil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/Perfil');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.pop(context);
              // Navigator.pushReplacementNamed(context, '/configuracoes');
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Suporte'),
            onTap: () {
              Navigator.pushNamed(context, '/suporte');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () async {
              Navigator.pop(context);
              await UsuarioService.logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
