import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Wellspace/models/Sala.dart';

class BookingStep4 extends StatelessWidget {
  final Sala sala;
  final DateTime selectedDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int numberOfPeople;
  final String paymentMethod;
  final double total;
  final bool acceptedTerms;
  final ValueChanged<bool?> onTermsChanged;

  const BookingStep4({
    super.key,
    required this.sala,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.numberOfPeople,
    required this.paymentMethod,
    required this.total,
    required this.acceptedTerms,
    required this.onTermsChanged,
  });

  String _formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);
  String _formatTime(BuildContext context, TimeOfDay time) =>
      time.format(context);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    final durationInHours = (endMinutes - startMinutes) / 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verifique os detalhes da sua reserva antes de confirmar',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
          ),
          child: Column(
            children: <Widget>[
              _buildReviewRow(context, 'Espaço:', sala.nomeSala),
              _buildReviewRow(context, 'Tipo de Reserva:', 'Reserva Imediata'),
              _buildReviewRow(context, 'Data:', _formatDate(selectedDate)),
              _buildReviewRow(context, 'Horário:',
                  '${_formatTime(context, startTime)} - ${_formatTime(context, endTime)}'),
              _buildReviewRow(context, 'Duração:',
                  '${durationInHours.toStringAsFixed(1).replaceAll('.0', '')} hora(s)'),
              _buildReviewRow(context, 'Pessoas:', '$numberOfPeople'),
              _buildReviewRow(context, 'Método de Pagamento:',
                  paymentMethod == 'credit' ? 'Cartão de Crédito' : 'Pix'),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    'R\$ ${total.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: theme.colorScheme.onSecondaryContainer, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Política de Cancelamento',
                        style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSecondaryContainer)),
                    const SizedBox(height: 4),
                    Text(
                      'Cancelamento gratuito até 24 horas antes do início da reserva. Após esse período, será cobrada uma taxa de 50% do valor total.',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer
                              .withOpacity(0.8),
                          height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: acceptedTerms,
                onChanged: onTermsChanged,
                activeColor: theme.colorScheme.primary,
                checkColor: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurface),
                  children: [
                    const TextSpan(text: 'Eu concordo com os '),
                    TextSpan(
                      text: 'Termos de Uso',
                      style: TextStyle(
                          color: theme.colorScheme.primary,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: ' e confirmo que li a '),
                    TextSpan(
                      text: 'Política de Privacidade',
                      style: TextStyle(
                          color: theme.colorScheme.primary,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7))),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
