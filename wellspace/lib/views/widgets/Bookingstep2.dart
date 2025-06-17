import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class BookingStep2 extends StatelessWidget {
  final DateTime selectedDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onStartTimeChanged;
  final ValueChanged<TimeOfDay> onEndTimeChanged;

  const BookingStep2({
    super.key,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.onDateChanged,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
  });

  String _formatDate(DateTime date) {
    initializeDateFormatting('pt_BR');
    return DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR').format(date);
  }

  String _formatTime(BuildContext context, TimeOfDay time) =>
      time.format(context);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<TimeOfDay> availableTimes =
        List.generate(12, (i) => TimeOfDay(hour: 8 + i, minute: 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Selecione a data e o horário da sua reserva',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            )),
        const SizedBox(height: 24),
        Text('Data da Reserva',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        _buildPickerTile(
          context: context,
          icon: Icons.calendar_today_outlined,
          value: _formatDate(selectedDate),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
              locale: const Locale('pt', 'BR'),
            );
            if (date != null) onDateChanged(date);
          },
        ),
        const SizedBox(height: 24),
        Text('Horário',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hora de Início',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7))),
                  const SizedBox(height: 4),
                  _buildPickerTile(
                    context: context,
                    icon: Icons.access_time,
                    value: _formatTime(context, startTime),
                    onTap: () async {
                      final time = await showTimePicker(
                          context: context, initialTime: startTime);
                      if (time != null) onStartTimeChanged(time);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hora de Término',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7))),
                  const SizedBox(height: 4),
                  _buildPickerTile(
                    context: context,
                    icon: Icons.access_time_filled,
                    value: _formatTime(context, endTime),
                    onTap: () async {
                      final time = await showTimePicker(
                          context: context, initialTime: endTime);
                      if (time != null) onEndTimeChanged(time);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Horários Disponíveis (Início)',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: availableTimes.map((time) {
            bool isSelected =
                time.hour == startTime.hour && time.minute == startTime.minute;
            return ChoiceChip(
              label: Text(_formatTime(context, time)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onStartTimeChanged(time);
                }
              },
              backgroundColor: theme.colorScheme.surfaceVariant,
              selectedColor: theme.colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: isSelected
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withOpacity(0.5)),
              ),
              showCheckmark: false,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPickerTile({
    required BuildContext context,
    required IconData icon,
    required String value,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border:
                Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 12),
              Text(value,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
