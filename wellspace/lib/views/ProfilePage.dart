import 'package:flutter/material.dart';
import '../views/widgets/sideMenu.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedTabIndex = 0;

  void changeTab(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

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
            // card que cntem o perfil
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: const Color(0xFFF9F4FC),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 16.0),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        child:
                            Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Ana Carolina Silva",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text("São Paulo, SP"),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Identidade verificada",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          _InfoItem(
                              icon: Icons.calendar_today,
                              text: "Desde\nmar/2022"),
                          _InfoItem(
                              icon: Icons.email, text: "ana.silva@email.com"),
                          _InfoItem(icon: Icons.phone, text: "(11) 98765-4321"),
                          _InfoItem(icon: Icons.work, text: "Médica"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text("Editar perfil"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          side: const BorderSide(color: Colors.black26),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Abas que podem fazera mudança de conteúdo
            _ProfileTabs(
              selectedIndex: selectedTabIndex,
              onTabChanged: changeTab,
            ),

            const SizedBox(height: 24),

            // Conteúdo das abas
            IndexedStack(
              index: selectedTabIndex,
              children: [
                _informacoesTab(),
                _placeholderTab("Verificação de identidade"),
                _placeholderTab("Seus favoritos aparecerão aqui."),
                _placeholderTab("Suas reservas aparecerão aqui."),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _informacoesTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Informações Pessoais"),
        _buildInfoTile("Organização", "Hospital São Lucas"),
        _buildInfoTile("Localização", "São Paulo, SP"),
        _buildInfoTile(
          "Biografia",
          "Médica cardiologista com 8 anos de experiência. Utilizo espaços de coworking para atendimentos particulares e reuniões profissionais.",
        ),
        const SizedBox(height: 24),
        _buildSectionTitle("Preferências"),
        _buildCheckboxTile("Notificações por email", true),
        _buildCheckboxTile("Notificações por SMS", false),
        _buildCheckboxTile("Perfil público", false),
      ],
    );
  }

  Widget _placeholderTab(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Text(message, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(value),
    );
  }

  Widget _buildCheckboxTile(String title, bool value) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: (val) {},
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

// WIDGET DAS INFORMAÇOES
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ProfileTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const _ProfileTabs({
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final labels = ["Informações", "Verificação", "Favoritos", "Reservas"];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            child: InkWell(
              onTap: () => onTabChanged(index),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius:
                      isSelected ? BorderRadius.circular(8) : BorderRadius.zero,
                ),
                child: Center(
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
