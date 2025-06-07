import 'package:flutter/material.dart';
import '../models/Sala.dart';

class ReservaEspacoScreen extends StatefulWidget {
  final Sala sala;
  final List<String> imagens;

  const ReservaEspacoScreen({
    super.key,
    required this.sala,
    required this.imagens,
  });

  @override
  State<ReservaEspacoScreen> createState() => _ReservaEspacoScreenState();
}

class _ReservaEspacoScreenState extends State<ReservaEspacoScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  int _people = 1;

  double get currentPricePerHour => widget.sala.precoHora;

  double get totalPrice {
    if (_startTime == null || _endTime == null) return 0;
    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
    if (endMinutes <= startMinutes) return 0;
    final duration = (endMinutes - startMinutes) / 60.0;
    return (duration * currentPricePerHour * _people).clamp(0, double.infinity);
  }

  Future<void> _pickDate() async {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: colorScheme.copyWith(
              primary: colorScheme.primary,
              onPrimary: colorScheme.onPrimary,
              surface: colorScheme.surface,
              onSurface: colorScheme.onSurface,
            ),
            dialogBackgroundColor: theme.dialogBackgroundColor,
          ),
          child: child!,
        );
      },
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime(bool isStart) async {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final sala = widget.sala;
    TimeOfDay initialTime = const TimeOfDay(hour: 9, minute: 0);

    if (sala != null) {
      try {
        if (isStart && sala.disponibilidadeInicio.isNotEmpty) {
          final parts = sala.disponibilidadeInicio.split(':');
          initialTime =
              TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        } else if (!isStart && sala.disponibilidadeFim.isNotEmpty) {
          final parts = sala.disponibilidadeFim.split(':');
          initialTime =
              TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
      } catch (e) {}
    }
    initialTime = isStart
        ? (_startTime ?? initialTime)
        : (_endTime ??
            TimeOfDay(hour: initialTime.hour + 1, minute: initialTime.minute));

    final time = await showTimePicker(
        context: context,
        initialTime: initialTime,
        builder: (context, child) {
          return Theme(
            data: theme.copyWith(
              colorScheme: colorScheme.copyWith(
                primary: colorScheme.primary,
                onPrimary: colorScheme.onPrimary,
                surface: colorScheme.surface,
                onSurface: colorScheme.onSurface,
              ),
              timePickerTheme: theme.timePickerTheme.copyWith(
                backgroundColor: theme.dialogBackgroundColor,
              ),
            ),
            child: child!,
          );
        });

    if (time != null) {
      setState(() {
        if (isStart) {
          _startTime = time;
          if (_endTime != null) {
            final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
            final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
            if (startMinutes >= endMinutes) _endTime = null;
          }
        } else {
          if (_startTime != null) {
            final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
            final endMinutes = time.hour * 60 + time.minute;
            if (endMinutes > startMinutes) {
              _endTime = time;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'O horário de término deve ser após o horário de início.')),
              );
            }
          } else {
            _endTime = time;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    bool podeFinalizarReserva = _selectedDate != null &&
        _startTime != null &&
        _endTime != null &&
        totalPrice > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar: ${widget.sala.nomeSala}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSalaHeader(theme),
            const SizedBox(height: 24),
            const Text(
              'Selecione os detalhes da sua reserva',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildReservationForm(context, theme),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: podeFinalizarReserva
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Reserva finalizada no valor de R\$ ${totalPrice.toStringAsFixed(2)}! (Implementar próximo passo)')));
                }
              : null,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            backgroundColor: theme.colorScheme.primary,
            disabledBackgroundColor:
                theme.colorScheme.onSurface.withOpacity(0.12),
            foregroundColor: theme.colorScheme.onPrimary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text('Confirmar e Pagar R\$ ${totalPrice.toStringAsFixed(2)}'),
        ),
      ),
    );
  }

  Widget _buildSalaHeader(ThemeData theme) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          SizedBox(
            width: 120,
            height: 100,
            child: widget.imagens.isNotEmpty
                ? Image.network(widget.imagens.first, fit: BoxFit.cover)
                : Container(
                    color: theme.colorScheme.surfaceVariant,
                    child: Icon(Icons.business)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.sala.nomeSala, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('R\$ ${widget.sala.precoHora.toStringAsFixed(2)} por hora',
                      style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildReservationForm(BuildContext context, ThemeData theme) {
    InputDecoration formFieldDecoration(String label, String hint,
        {Widget? suffixIcon}) {
      return InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: theme.colorScheme.outline.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
        labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        hintStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7)),
        suffixIcon: suffixIcon != null
            ? IconTheme(
                data: IconThemeData(color: theme.colorScheme.onSurfaceVariant),
                child: suffixIcon)
            : null,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickDate,
          child: AbsorbPointer(
            child: TextFormField(
              key: ValueKey('date-${_selectedDate?.toIso8601String()}'),
              initialValue: _selectedDate == null
                  ? null
                  : '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}',
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: formFieldDecoration('Data', 'Selecione a data',
                  suffixIcon: const Icon(Icons.calendar_today)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _pickTime(true),
                child: AbsorbPointer(
                  child: TextFormField(
                    key: ValueKey('start-${_startTime?.format(context)}'),
                    initialValue: _startTime?.format(context),
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: formFieldDecoration('Início', 'HH:MM'),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => _pickTime(false),
                child: AbsorbPointer(
                  child: TextFormField(
                    key: ValueKey('end-${_endTime?.format(context)}'),
                    initialValue: _endTime?.format(context),
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: formFieldDecoration('Término', 'HH:MM'),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        
  
        Align(
          alignment: Alignment.center,
          child: Text(
              'Total da Reserva: R\$ ${totalPrice.toStringAsFixed(2)}',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}