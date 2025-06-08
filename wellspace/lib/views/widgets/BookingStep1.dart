import 'package:flutter/material.dart';

class BookingStep1 extends StatelessWidget {
  final String bookingType;
  final ValueChanged<String> onChanged;

  const BookingStep1({
    super.key,
    required this.bookingType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Escolha como deseja realizar sua reserva', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 16),
        _buildBookingTypeOption(
          context: context,
          title: 'Reserva Imediata',
          subtitle: 'Sua reserva é confirmada automaticamente, sem necessidade de aprovação do anfitrião. Ideal para quem precisa de garantia imediata.',
          value: 'immediate',
          icon: Icons.check_circle_outline,
          tag: 'Recomendado',
        ),
        const SizedBox(height: 16),
        _buildBookingTypeOption(
          context: context,
          title: 'Reserva com Confirmação',
          subtitle: 'Sua solicitação de reserva será enviada ao anfitrião, que terá até 24 horas para confirmar. O pagamento só será processado após a confirmação.',
          value: 'confirmation',
          icon: Icons.hourglass_empty_outlined,
          tag: 'Resposta em até 24h',
        ),
      ],
    );
  }

  Widget _buildBookingTypeOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
    String? tag,
  }) {
    final theme = Theme.of(context);
    final isSelected = bookingType == value;
    final primaryColor = const Color(0xFF4F46E5);

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.05) : Colors.transparent,
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                if (tag != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(tag, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w500)),
                  ),
                const SizedBox(width: 8),
                Radio<String>(
                  value: value,
                  groupValue: bookingType,
                  onChanged: (val) => onChanged(val!),
                  activeColor: primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(subtitle, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(icon, color: isSelected ? primaryColor : Colors.grey.shade600, size: 16),
                const SizedBox(width: 4),
                Text(value == 'immediate' ? 'Confirmação instantânea' : 'Resposta em até 24h', style: TextStyle(fontSize: 14, color: isSelected ? primaryColor : Colors.grey.shade600, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}