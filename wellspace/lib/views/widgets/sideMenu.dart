import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(Icons.person, color: Colors.blue),
                ),
                SizedBox(height: 10),
                Text(
                  'João Silva',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ver perfil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () {
              // Ação para navegar para a tela de Início
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Explorar Espaços'),
            onTap: () {
              // Ação para navegar para explorar espaços
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Minhas Reservas'),
            onTap: () {
              // Ação para navegar para as reservas
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_business),
            title: const Text('Cadastrar Sala'),
            onTap: () {
              // Ação para navegar para o cadastro de sala
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Cadastrar Localidade'),
            onTap: () {
              // Ação para navegar para o cadastro de localidade
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Meu Perfil'),
            onTap: () {
              // Ação para navegar para o perfil do usuário
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              // Ação para navegar para configurações
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Suporte'),
            onTap: () {
              // Ação para navegar para o suporte
            },
          ),
        ],
      ),
    );
  }
}
