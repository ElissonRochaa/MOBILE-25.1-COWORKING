import 'package:flutter/material.dart';
import '../views/widgets/sideMenu.dart';

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
            // Card de Perfil
            _buildProfileCard(),

            const SizedBox(height: 16),

            // Abas
            _buildTabBar(),

            const SizedBox(height: 24),

            // Conteúdo da aba
            IndexedStack(
              index: _selectedTab,
              children: [
                _informacoesTab(),
                _verificacaoTab(),
                _placeholderTab("Favoritos"),
                _placeholderTab("Reservas"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFFF9F4FC),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              "Ana Carolina Silva",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text("São Paulo, SP"),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 10,
              children: const [
                _InfoItem(
                    icon: Icons.calendar_today,
                    text: "Membro desde março 2022"),
                _InfoItem(icon: Icons.email, text: "ana.silva@email.com"),
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
    );
  }

  Widget _buildTabBar() {
    final tabs = ['Informações', 'Verificação', 'Favoritos', 'Reservas'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(tabs.length, (index) {
        final selected = _selectedTab == index;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedTab = index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selected ? Colors.grey[200] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                tabs[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }),
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

  Widget _verificacaoTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Verificação de Identidade",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          "Verifique sua identidade para aumentar a confiança e segurança",
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.shield, color: Colors.blue),
              SizedBox(width: 12),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Por que verificar sua identidade?\n",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text:
                            "A verificação de identidade aumenta a segurança e confiança na plataforma. Espaços de coworking podem exigir verificação para reservas.",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Documentos para verificação",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _documentoCard("RG (Identidade)", "documento_rg.pdf", "Verificado"),
            _documentoCard("CPF", "documento_cpf.pdf", "Verificado"),
            _documentoCard(
                "CRM / Registro Profissional", "crm_sp.pdf", "Verificado"),
          ],
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Identidade verificada\n",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      TextSpan(
                        text:
                            "Sua identidade foi verificada com sucesso. Você tem acesso completo à plataforma.",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _documentoCard(String titulo, String arquivo, String status) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Documento de identificação",
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(arquivo)),
                const Icon(Icons.delete_outline, color: Colors.red),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
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

  Widget _placeholderTab(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.black54),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }
}
