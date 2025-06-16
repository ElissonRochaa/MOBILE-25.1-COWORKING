import 'package:Wellspace/models/Reserva.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Wellspace/views/widgets/SalaCard.dart';

class ReservaInfoCard extends StatelessWidget {
  final Reserva reserva;

  const ReservaInfoCard({super.key, required this.reserva});

  String _formatarData(String data) {
    try {
      final dateTime = DateTime.parse(data);
      return DateFormat('dd \'de\' MMMM \'de\' yyyy', 'pt_BR').format(dateTime);
    } catch (e) {
      return data;
    }
  }

  String _formatarHora(String hora) {
    try {
      final timeParts = hora.split(':');
      return '${timeParts[0]}:${timeParts[1]}';
    } catch (e) {
      return hora;
    }
  }

  Widget _buildStatusChip(String status) {
    Color corFundo;
    Color corTexto;
    IconData icone;

    switch (status.toUpperCase()) {
      case 'CONFIRMADA':
        corFundo = Colors.green.shade50;
        corTexto = Colors.green.shade800;
        icone = Icons.check_circle_outline;
        break;
      case 'CANCELADA':
        corFundo = Colors.red.shade50;
        corTexto = Colors.red.shade800;
        icone = Icons.cancel_outlined;
        break;
      case 'PENDENTE':
      default:
        corFundo = Colors.orange.shade50;
        corTexto = Colors.orange.shade800;
        icone = Icons.hourglass_empty_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, color: corTexto, size: 16),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: corTexto,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SalaCard(sala: reserva.sala),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detalhes da Reserva',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.textTheme.titleMedium?.color,
                      ),
                    ),
                    _buildStatusChip(reserva.statusReserva),
                  ],
                ),
                const SizedBox(height: 12),
                InfoLinha(
                  icone: Icons.calendar_today_outlined,
                  texto: _formatarData(reserva.dataReserva),
                ),
                const SizedBox(height: 8),
                InfoLinha(
                  icone: Icons.access_time_filled_outlined,
                  texto:
                      'Das ${_formatarHora(reserva.horaInicio)} às ${_formatarHora(reserva.horaFim)}',
                ),
                const SizedBox(height: 8),
                InfoLinha(
                  icone: Icons.person_outline,
                  texto: 'Locador: ${reserva.locador.nome}',
                ),
                const SizedBox(height: 8),
                InfoLinha(
                  icone: Icons.monetization_on_outlined,
                  texto:
                      'Valor Total: R\$ ${reserva.valorTotal.toStringAsFixed(2)}',
                  corTexto: theme.colorScheme.primary,
                  isBold: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoLinha extends StatelessWidget {
  final IconData icone;
  final String texto;
  final Color? corTexto;
  final bool isBold;

  const InfoLinha({
    super.key,
    required this.icone,
    required this.texto,
    this.corTexto,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icone,
            size: 18, color: theme.colorScheme.onSurface.withOpacity(0.6)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            texto,
            style: TextStyle(
              fontSize: 14,
              color: corTexto ?? theme.textTheme.bodyLarge?.color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
