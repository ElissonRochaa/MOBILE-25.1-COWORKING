import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/Reserva.dart';

class ReservaRecebidaCard extends StatelessWidget {
  final Reserva reserva;

  const ReservaRecebidaCard({super.key, required this.reserva});

  Widget _buildStatusChip(String status, BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status.toUpperCase()) {
      case 'CONFIRMADA':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        icon = Icons.check_circle;
        break;
      case 'CANCELADA':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        icon = Icons.cancel;
        break;
      default:
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        icon = Icons.hourglass_empty;
    }

    return Chip(
      avatar: Icon(icon, color: textColor, size: 16),
      label: Text(
        status,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
      ),
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(reserva.dataReserva)); // Use existing date format

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    reserva.sala.nomeSala, // Access sala name from nested object
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusChip(reserva.statusReserva, context), // Use existing status field
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.person, "Locatário:", reserva.locatario.nome, context), // Access locatario name
            const SizedBox(height: 8),
            _buildInfoRow(Icons.calendar_today, "Data:", formattedDate, context),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.access_time, "Horário:", '${reserva.horaInicio} - ${reserva.horaFim}', context),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total: R\$ ${reserva.valorTotal.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.6)),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}