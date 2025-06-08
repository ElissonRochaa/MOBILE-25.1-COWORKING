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
  
  String _formatDate(DateTime date) => DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR').format(date);
  String _formatTime(BuildContext context, TimeOfDay time) => time.format(context);

  @override
  Widget build(BuildContext context) {
    // Lista de horários de exemplo
    final List<TimeOfDay> availableTimes = List.generate(12, (i) => TimeOfDay(hour: 8 + i, minute: 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Selecione a data e o horário da sua reserva', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 24),
        
        const Text('Data da Reserva', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        _buildPickerTile(
          context: context,
          icon: Icons.calendar_today,
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
        const Text('Horário', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hora de Início', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 4),
                  _buildPickerTile(
                    context: context,
                    icon: Icons.access_time,
                    value: _formatTime(context, startTime),
                    onTap: () async {
                      final time = await showTimePicker(context: context, initialTime: startTime);
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
                  const Text('Hora de Término', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 4),
                  _buildPickerTile(
                    context: context,
                    icon: Icons.access_time_filled,
                    value: _formatTime(context, endTime),
                    onTap: () async {
                      final time = await showTimePicker(context: context, initialTime: endTime);
                      if (time != null) onEndTimeChanged(time);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),
        const Text('Horários Disponíveis', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: availableTimes.map((time) {
            bool isSelected = time.hour == startTime.hour && time.minute == startTime.minute;
            return ChoiceChip(
              label: Text(_formatTime(context, time)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onStartTimeChanged(time);
                }
              },
              selectedColor: const Color(0xFF4F46E5).withOpacity(0.1),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF4F46E5) : Colors.black87, 
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isSelected ? const Color(0xFF4F46E5) : Colors.grey.shade300)
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),
        const Text('Número de Pessoas', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => (numberOfPeople > 1) ? onPeopleChanged(numberOfPeople - 1) : null,
              color: Colors.grey,
            ),
            Text('$numberOfPeople', style: Theme.of(context).textTheme.titleLarge),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => onPeopleChanged(numberOfPeople + 1),
              color: const Color(0xFF4F46E5),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildPickerTile({
    required BuildContext context,
    required IconData icon,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade600, size: 20),
            const SizedBox(width: 8),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}