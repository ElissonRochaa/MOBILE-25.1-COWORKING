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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _buildBookingTypeOption(
              theme: theme,
              title: 'Reserva Imediata',
              subtitle: 'Confirmação automática e instantânea.',
              value: 'immediate',
              icon: Icons.flash_on,
            ),
            const SizedBox(height: 12),
            _buildBookingTypeOption(
              theme: theme,
              title: 'Reserva com Confirmação',
              subtitle: 'Aguarde a aprovação do anfitrião.',
              value: 'confirmation',
              icon: Icons.hourglass_top,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingTypeOption({
    required ThemeData theme,
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
  }) {
    final isSelected = bookingType == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
