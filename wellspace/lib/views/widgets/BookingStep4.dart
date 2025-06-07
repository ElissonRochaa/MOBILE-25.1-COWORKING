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
  String _formatTime(BuildContext context, TimeOfDay time) => time.format(context);
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 0,
          color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildReviewRow(context, 'Espaço:', sala.nomeSala),
                _buildReviewRow(context, 'Data:', _formatDate(selectedDate)),
                _buildReviewRow(
                    context, 'Horário:', '${_formatTime(context, startTime)} - ${_formatTime(context, endTime)}'),
                _buildReviewRow(context, 'Pessoas:', '$numberOfPeople'),
                _buildReviewRow(
                    context, 'Pagamento:', paymentMethod == 'credit' ? 'Cartão de Crédito' : 'Pix'),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total:', style: theme.textTheme.titleLarge),
                    Text(
                      'R\$ ${total.toStringAsFixed(2)}',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: theme.dividerColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: theme.colorScheme.onSurfaceVariant, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Política de Cancelamento', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        'Cancelamento gratuito até 24 horas antes do início da reserva. Após esse período, será cobrada uma taxa de 50% do valor total.',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
                        child: const Text('Ver política completa'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: acceptedTerms,
                onChanged: onTermsChanged,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: theme.textTheme.bodySmall,
                  children: [
                    const TextSpan(text: 'Eu concordo com os '),
                    TextSpan(
                      text: 'Termos de Uso',
                      style: TextStyle(color: theme.colorScheme.primary, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: ' e confirmo que li a '),
                    TextSpan(
                      text: 'Política de Privacidade',
                      style: TextStyle(color: theme.colorScheme.primary, decoration: TextDecoration.underline),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
