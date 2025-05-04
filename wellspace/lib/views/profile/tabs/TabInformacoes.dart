import 'package:flutter/material.dart';

class InformacoesTab extends StatelessWidget {
  const InformacoesTab({super.key});

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

  @override
  Widget build(BuildContext context) {
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
}
