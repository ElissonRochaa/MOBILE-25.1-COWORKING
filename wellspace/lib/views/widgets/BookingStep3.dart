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
    const primaryColor = Color(0xFF4F46E5);
    final isCreditCard = paymentMethod == 'credit';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Escolha como deseja realizar o pagamento', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 16),
        
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildPaymentToggle(
                  label: 'Cartão',
                  icon: Icons.credit_card,
                  isSelected: isCreditCard,
                  onTap: () => onChanged('credit'),
                ),
              ),
              Expanded(
                child: _buildPaymentToggle(
                  label: 'Pix',
                  icon: Icons.qr_code_2,
                  isSelected: !isCreditCard,
                  onTap: () => onChanged('pix'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        Visibility(
          visible: isCreditCard,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _buildTextFormField(label: 'Número do Cartão', icon: Icons.shield_outlined, type: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextFormField(label: 'Nome no Cartão', icon: Icons.person_outline),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextFormField(label: 'Data de Validade', hint: 'MM/AA')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextFormField(label: 'CVC', hint: '123', icon: Icons.info_outline, type: TextInputType.number)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.lock, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Text('Seus dados de pagamento estão seguros', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: !isCreditCard,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Icon(Icons.qr_code_scanner, size: 120, color: Colors.grey.shade800),
              ),
              const SizedBox(height: 16),
              const Text('Escaneie o QR Code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              const Text('Use o aplicativo do seu banco para escanear', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text('Copiar código Pix'),
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentToggle({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    const primaryColor = Color(0xFF4F46E5);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? primaryColor : Colors.grey.shade600, size: 20),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? primaryColor : Colors.grey.shade800)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({required String label, String? hint, IconData? icon, TextInputType? type}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: icon != null ? Icon(icon, size: 20) : null,
      ),
      keyboardType: type,
      validator: (value) => (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
    );
  }
}