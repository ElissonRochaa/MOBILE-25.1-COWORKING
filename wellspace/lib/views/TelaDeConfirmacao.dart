import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Wellspace/models/Sala.dart';
import 'package:Wellspace/views/ConfirmationPage.dart';

class TelaConfirmacaoReserva extends StatelessWidget {
  final Sala sala;
  final DateTime selectedDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int numberOfPeople;
  final double total;

  const TelaConfirmacaoReserva({
    super.key,
    required this.sala,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.numberOfPeople,
    required this.total,
  });

  void _submitBooking(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ConfirmationPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4F46E5);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Confirme Sua Reserva'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: _ResumoReservaCard(
              sala: sala,
              date: selectedDate,
              startTime: startTime,
              endTime: endTime,
              people: numberOfPeople,
              total: total,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Voltar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _submitBooking(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Confirmar Reserva'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumoReservaCard extends StatelessWidget {
  final Sala sala;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int people;
  final double total;

  const _ResumoReservaCard({
    required this.sala,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.people,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primaryColor = Color(0xFF4F46E5);
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    final durationInHours = (endMinutes - startMinutes) / 60;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resumo da Reserva', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.image, color: Colors.grey.shade400),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sala.nomeSala, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const Text("Av. Paulista, 1000, São Paulo", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            ],
          ),
          const Divider(height: 32),
          _buildSummaryRow('Data:', DateFormat('dd/MM/yyyy').format(date)),
          _buildSummaryRow('Horário:', '${startTime.format(context)} - ${endTime.format(context)}'),
          _buildSummaryRow('Duração:', '${durationInHours.toStringAsFixed(0)} hora(s)'),
          _buildSummaryRow('Pessoas:', '$people'),
          const Divider(height: 32),
          _buildSummaryRow('Preço por hora:', 'R\$ ${sala.precoHora.toStringAsFixed(2)}'),
          _buildSummaryRow('Duração:', '${durationInHours.toStringAsFixed(0)} hora(s)'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Text('R\$ ${total.toStringAsFixed(2)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: primaryColor)),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoChip(Icons.info_outline, 'Sua reserva será confirmada imediatamente após o pagamento.', Colors.blue.shade50),
          const SizedBox(height: 12),
          _buildInfoChip(Icons.shield_outlined, 'Pagamento seguro e criptografado', Colors.green.shade50),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 12, color: Colors.grey.shade700))),
        ],
      ),
    );
  }
}