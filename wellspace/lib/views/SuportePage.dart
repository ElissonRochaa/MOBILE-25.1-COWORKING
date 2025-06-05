import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/SuporteViewModel.dart';

class SuportePage extends StatelessWidget {
  const SuportePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SuporteViewModel(),
      child: const _SuporteView(),
    );
  }
}

class _SuporteView extends StatefulWidget {
  const _SuporteView();

  @override
  State<_SuporteView> createState() => _SuporteViewState();
}

class _SuporteViewState extends State<_SuporteView> {
  final List<Map<String, String>> _faq = [
    {
      "question": "Como faço uma reserva de sala?",
      "answer":
          "Basta acessar a aba de busca, selecionar a sala desejada, escolher a data e horário e confirmar a reserva."
    },
    {
      "question": "Posso cancelar uma reserva?",
      "answer":
          "Sim, reservas podem ser canceladas com até 24h de antecedência sem custo. Vá até a aba 'Reservas' e clique em 'Cancelar'."
    },
    {
      "question": "Quais formas de pagamento são aceitas?",
      "answer":
          "Aceitamos cartão de crédito, débito e Pix diretamente pelo app."
    },
    {
      "question": "O que fazer se a sala estiver trancada?",
      "answer":
          "Entre em contato com o suporte via chat informando o problema. Um atendente estará disponível para ajudar."
    },
  ];

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SuporteViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Suporte')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Dúvidas Frequentes",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: _faq.length,
                itemBuilder: (context, index) {
                  final item = _faq[index];
                  return ExpansionTile(
                    title: Text(item['question']!),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: Text(item['answer']!),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              "Atendimento via Chat",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: viewModel.chatMessages.length,
                itemBuilder: (context, index) {
                  final message = viewModel.chatMessages[index];
                  final isUser = message['from'] == 'user';
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Colors.blueAccent.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(message['text']!),
                    ),
                  );
                },
              ),
            ),
            if (viewModel.isLoading) const CircularProgressIndicator(),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Digite sua mensagem...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: viewModel.isLoading
                      ? null
                      : () {
                          final text = _messageController.text;
                          _messageController.clear();
                          viewModel.sendMessage(text);
                        },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
