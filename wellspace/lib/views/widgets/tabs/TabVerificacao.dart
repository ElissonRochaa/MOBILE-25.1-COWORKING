import 'package:flutter/material.dart';

class VerificacaoTab extends StatelessWidget {
  const VerificacaoTab({super.key});

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

  @override
  Widget build(BuildContext context) {
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
}
