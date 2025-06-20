import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wellspace/views/widgets/ThemeNotifer.dart';

class VerificacaoTab extends StatelessWidget {
  const VerificacaoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDark = themeNotifier.isDarkMode;
    final backgroundColor = isDark ? Colors.grey[800] : Colors.blue[50];
    final statusColor = isDark ? Colors.green[300] : Colors.green[50];
    final statusTextColor = isDark ? Colors.green[100] : Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Verificação de Identidade",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Verifique sua identidade para aumentar a confiança e segurança",
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.shield,
                  color: isDark ? Colors.blue[300] : Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Por que verificar sua identidade?\n",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      TextSpan(
                        text:
                            "A verificação de identidade aumenta a segurança e confiança na plataforma. Espaços de coworking podem exigir verificação para reservas.",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "Documentos para verificação",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _documentoCard(
              "RG (Identidade)",
              "documento_rg.pdf",
              "Verificado",
              // ajuste cores aqui se quiser, usando isDark
            ),
            _documentoCard("CPF", "documento_cpf.pdf", "Verificado"),
            _documentoCard(
                "CRM / Registro Profissional", "crm_sp.pdf", "Verificado"),
          ],
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green[400]),
              const SizedBox(width: 8),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Identidade verificada\n",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      TextSpan(
                        text:
                            "Sua identidade foi verificada com sucesso. Você tem acesso completo à plataforma.",
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
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
}
