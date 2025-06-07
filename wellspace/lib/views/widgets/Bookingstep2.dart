import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingStep2 extends StatelessWidget {
  final DateTime selectedDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int numberOfPeople;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onStartTimeChanged;
  final ValueChanged<TimeOfDay> onEndTimeChanged;
  final ValueChanged<int> onPeopleChanged;

  const BookingStep2({
    super.key,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.numberOfPeople,
    required this.onDateChanged,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
    required this.onPeopleChanged,
  });
  
  String _formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);
  String _formatTime(BuildContext context, TimeOfDay time) => time.format(context);

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildPickerTile(
              context: context,
              icon: Icons.calendar_today,
              label: 'Data',
              value: _formatDate(selectedDate),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (date != null) onDateChanged(date);
              },
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildPickerTile(
                    context: context,
                    icon: Icons.access_time,
                    label: 'Início',
                    value: _formatTime(context, startTime),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: startTime,
                      );
                      if (time != null) onStartTimeChanged(time);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPickerTile(
                    context: context,
                    icon: Icons.access_time_filled,
                    label: 'Término',
                    value: _formatTime(context, endTime),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: endTime,
                      );
                      if (time != null) onEndTimeChanged(time);
                    },
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text('Número de Pessoas'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (numberOfPeople > 1) {
                      onPeopleChanged(numberOfPeople - 1);
                    }
                  },
                ),
                Text('$numberOfPeople', style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    onPeopleChanged(numberOfPeople + 1);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPickerTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Text(value, style: theme.textTheme.titleMedium),
            ],
          ),
        ],
      ),
    );
  }
}
