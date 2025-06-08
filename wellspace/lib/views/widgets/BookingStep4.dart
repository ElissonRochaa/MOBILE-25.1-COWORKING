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
    const primaryColor = Color(0xFF4F46E5);
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    final durationInHours = (endMinutes - startMinutes) / 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Verifique os detalhes da sua reserva antes de confirmar', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: <Widget>[
              _buildReviewRow('Espaço:', sala.nomeSala),
              _buildReviewRow('Tipo de Reserva:', 'Reserva Imediata'), // Exemplo
              _buildReviewRow('Data:', _formatDate(selectedDate)),
              _buildReviewRow('Horário:', '${_formatTime(context, startTime)} - ${_formatTime(context, endTime)}'),
              _buildReviewRow('Duração:', '${durationInHours.toStringAsFixed(0)} hora(s)'),
              _buildReviewRow('Pessoas:', '$numberOfPeople'),
              _buildReviewRow('Método de Pagamento:', paymentMethod == 'credit' ? 'Cartão de Crédito' : 'Pix'),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    'R\$ ${total.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: primaryColor),
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
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8)
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: primaryColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Política de Cancelamento', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      'Cancelamento gratuito até 24 horas antes do início da reserva. Após esse período, será cobrada uma taxa de 50% do valor total.',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: acceptedTerms,
              onChanged: onTermsChanged,
              activeColor: primaryColor,
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: theme.textTheme.bodySmall,
                  children: [
                    const TextSpan(text: 'Eu concordo com os '),
                    TextSpan(
                      text: 'Termos de Uso',
                      style: const TextStyle(color: primaryColor, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()..onTap = () { /* Navegar para Termos */ },
                    ),
                    const TextSpan(text: ' e confirmo que li a '),
                    TextSpan(
                      text: 'Política de Privacidade',
                      style: const TextStyle(color: primaryColor, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()..onTap = () { /* Navegar para Privacidade */ },
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

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value, 
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}