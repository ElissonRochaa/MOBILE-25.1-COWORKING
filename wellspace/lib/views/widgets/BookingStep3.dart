import 'package:flutter/material.dart';

class BookingStep3 extends StatelessWidget {
  final String paymentMethod;
  final GlobalKey<FormState> formKey;
  final ValueChanged<String> onChanged;

  const BookingStep3({
    super.key,
    required this.paymentMethod,
    required this.formKey,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              RadioListTile<String>(
                title: const Text('Cartão de Crédito'),
                value: 'credit',
                groupValue: paymentMethod,
                onChanged: (value) => onChanged(value!),
                 secondary: const Icon(Icons.credit_card),
              ),
              if (paymentMethod == 'credit')
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Número do Cartão'),
                        keyboardType: TextInputType.number,
                        validator: (value) => (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Nome no Cartão'),
                        validator: (value) => (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(labelText: 'MM/AA'),
                              validator: (value) => (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(labelText: 'CVC'),
                              keyboardType: TextInputType.number,
                              validator: (value) => (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              const Divider(height: 1),
              RadioListTile<String>(
                title: const Text('Pix'),
                value: 'pix',
                groupValue: paymentMethod,
                onChanged: (value) => onChanged(value!),
                secondary: const Icon(Icons.qr_code),
              ),
              if (paymentMethod == 'pix')
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: Text("Um QR Code será gerado na próxima tela.")),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
