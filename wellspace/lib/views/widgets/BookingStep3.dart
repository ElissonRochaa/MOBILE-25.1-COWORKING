import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    final isCreditCard = paymentMethod == 'credit';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Escolha como deseja realizar o pagamento',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            )),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildPaymentToggle(
                  context: context,
                  label: 'Cartão',
                  icon: Icons.credit_card_rounded,
                  isSelected: isCreditCard,
                  onTap: () => onChanged('credit'),
                ),
              ),
              Expanded(
                child: _buildPaymentToggle(
                  context: context,
                  label: 'Pix',
                  icon: Icons.qr_code_2_rounded,
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
                _buildTextFormField(
                    context: context,
                    label: 'Número do Cartão',
                    icon: Icons.shield_outlined,
                    type: TextInputType.number,
                    formatters: [FilteringTextInputFormatter.digitsOnly]),
                const SizedBox(height: 16),
                _buildTextFormField(
                    context: context,
                    label: 'Nome no Cartão',
                    icon: Icons.person_outline),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: _buildTextFormField(
                            context: context,
                            label: 'Validade',
                            hint: 'MM/AA',
                            type: TextInputType.datetime)),
                    const SizedBox(width: 16),
                    Expanded(
                        child: _buildTextFormField(
                            context: context,
                            label: 'CVC',
                            hint: '123',
                            icon: Icons.info_outline,
                            type: TextInputType.number,
                            formatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4)
                        ])),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.lock_outline_rounded,
                        size: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    const SizedBox(width: 8),
                    Text('Seus dados de pagamento estão seguros',
                        style: theme.textTheme.bodySmall?.copyWith(
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.6))),
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
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.qr_code_scanner_rounded,
                    size: 120, color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              Text('Escaneie o QR Code',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Use o aplicativo do seu banco para escanear',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7))),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.copy_all_outlined, size: 20),
                label: const Text('Copiar código Pix'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "Código Pix copiado! (Funcionalidade Simulado)")));
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(color: theme.colorScheme.outline),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentToggle({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.cardColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2))
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected
                    ? primaryColor
                    : theme.colorScheme.onSurface.withOpacity(0.6),
                size: 20),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? primaryColor
                        : theme.colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required BuildContext context,
    required String label,
    String? hint,
    IconData? icon,
    TextInputType? type,
    List<TextInputFormatter>? formatters,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: icon != null
            ? Icon(icon,
                size: 20, color: theme.colorScheme.onSurface.withOpacity(0.5))
            : null,
      ),
      keyboardType: type,
      inputFormatters: formatters,
      validator: (value) =>
          (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
    );
  }
}
