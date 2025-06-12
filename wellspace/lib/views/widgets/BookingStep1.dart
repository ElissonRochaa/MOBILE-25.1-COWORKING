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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Escolha como deseja realizar sua reserva',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),
        _buildBookingTypeOption(
          context: context,
          title: 'Reserva Imediata',
          subtitle:
              'Sua reserva é confirmada automaticamente, sem necessidade de aprovação do anfitrião. Ideal para quem precisa de garantia imediata.',
          value: 'immediate',
          icon: Icons.check_circle_outline_rounded,
          tag: 'Recomendado',
        ),
        const SizedBox(height: 16),
        _buildBookingTypeOption(
          context: context,
          title: 'Reserva com Confirmação',
          subtitle:
              'Sua solicitação de reserva será enviada ao anfitrião, que terá até 24 horas para confirmar. O pagamento só será processado após a confirmação.',
          value: 'confirmation',
          icon: Icons.hourglass_empty_rounded,
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

    final Color backgroundColor = isSelected
        ? theme.colorScheme.primary.withOpacity(0.08)
        : Colors.transparent;
    final Color borderColor =
        isSelected ? theme.colorScheme.primary : theme.colorScheme.outline;
    final Color subtitleColor = theme.colorScheme.onSurface.withOpacity(0.7);
    final Color iconAndDetailColor = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withOpacity(0.6);

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2.0 : 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                if (tag != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                Radio<String>(
                  value: value,
                  groupValue: bookingType,
                  onChanged: (val) => onChanged(val!),
                  activeColor: theme.colorScheme.primary,
                  fillColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return theme.colorScheme.primary;
                      }
                      return theme.colorScheme.onSurface.withOpacity(0.6);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(subtitle,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: subtitleColor, height: 1.4)),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(icon, color: iconAndDetailColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                      value == 'immediate'
                          ? 'Confirmação instantânea'
                          : 'Aguarde a confirmação',
                      style: TextStyle(
                          fontSize: 14,
                          color: iconAndDetailColor,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
