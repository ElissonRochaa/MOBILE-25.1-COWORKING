import 'package:flutter/material.dart';
import 'widgets/sideMenu.dart';
import 'widgets/ProfileCard.dart';
import 'widgets/TabBar.dart';
import 'widgets/tabs/TabInformacoes.dart';
import 'widgets/tabs/TabVerificacao.dart';
import 'widgets/tabs/TabFavoritos.dart';
import 'widgets/tabs/TabReservas.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const ProfileCard(),
            const SizedBox(height: 16),
            TabSelector(
              selectedTab: _selectedTab,
              onTabChanged: (index) => setState(() => _selectedTab = index),
            ),
            const SizedBox(height: 24),
            IndexedStack(
              index: _selectedTab,
              children: const [
                InformacoesTab(),
                VerificacaoTab(),
                FavoritosTab(),
                ReservasTab(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
