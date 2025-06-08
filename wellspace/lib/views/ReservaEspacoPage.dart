import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Wellspace/models/Sala.dart';
import 'package:Wellspace/views/widgets/BookingStep1.dart';
import 'package:Wellspace/views/widgets/BookingStep2.dart';
import 'package:Wellspace/views/widgets/BookingStep3.dart';
import 'package:Wellspace/views/widgets/BookingStep4.dart';
import 'package:Wellspace/views/ConfirmationPage.dart';

class ReservaStepperScreen extends StatefulWidget {
  final Sala sala;
  const ReservaStepperScreen({super.key, required this.sala});

  @override
  State<ReservaStepperScreen> createState() => _ReservaStepperScreenState();
}

class _ReservaStepperScreenState extends State<ReservaStepperScreen> {
  int _currentStep = 0;
  
  String bookingType = 'immediate';
  DateTime selectedDate = DateTime.now();
  TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 18, minute: 0);
  int numberOfPeople = 1;
  String paymentMethod = 'credit';
  final paymentFormKey = GlobalKey<FormState>();
  bool acceptedTerms = false;

  double _calculateTotal() {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    final durationInMinutes = endMinutes - startMinutes;

    if (durationInMinutes <= 0) return 0.0;
    
    final durationInHours = durationInMinutes / 60;
    return durationInHours * widget.sala.precoHora;
  }
  
  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _submitBooking();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.of(context).pop();
    }
  }

  void _submitBooking() {
    final isPaymentValid = (paymentMethod == 'credit' && (paymentFormKey.currentState?.validate() ?? false)) || paymentMethod == 'pix';
    if (isPaymentValid && acceptedTerms) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ConfirmationPage()));
    } else if (!acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você deve aceitar os termos e condições.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _getStepContent(int step) {
    switch (step) {
      case 0:
        return BookingStep1(bookingType: bookingType, onChanged: (value) => setState(() => bookingType = value));
      case 1:
        return BookingStep2(
          selectedDate: selectedDate,
          startTime: startTime,
          endTime: endTime,
          numberOfPeople: numberOfPeople,
          onDateChanged: (date) => setState(() => selectedDate = date),
          onStartTimeChanged: (time) => setState(() => startTime = time),
          onEndTimeChanged: (time) => setState(() => endTime = time),
          onPeopleChanged: (count) => setState(() => numberOfPeople = count),
        );
      case 2:
        return BookingStep3(
          paymentMethod: paymentMethod,
          formKey: paymentFormKey,
          onChanged: (value) => setState(() => paymentMethod = value),
        );
      case 3:
        return BookingStep4(
          sala: widget.sala,
          selectedDate: selectedDate,
          startTime: startTime,
          endTime: endTime,
          numberOfPeople: numberOfPeople,
          paymentMethod: paymentMethod,
          total: _calculateTotal(),
          acceptedTerms: acceptedTerms,
          onTermsChanged: (value) => setState(() => acceptedTerms = value ?? false),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4F46E5);
    final screenWidth = MediaQuery.of(context).size.width;
    // Um ponto de quebra mais comum para tablets/desktops pequenos
    final isLargeScreen = screenWidth > 800;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Reservar Espaço', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade300, height: 1.0),
        ),
      ),
      body: Center( // Centraliza o conteúdo na tela
        child: ConstrainedBox( // Adiciona um limite de largura máximo
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: isLargeScreen
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5, // A área do formulário ocupa mais espaço
                          child: _buildStepperContent(context),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          flex: 3, // O resumo ocupa menos espaço
                          child: _ResumoReservaCard(
                            sala: widget.sala,
                            date: selectedDate,
                            startTime: startTime,
                            endTime: endTime,
                            people: numberOfPeople,
                            total: _calculateTotal(),
                          ),
                        ),
                      ],
                    )
                  : Column( // Em telas pequenas, mostra um abaixo do outro
                      children: [
                        _buildStepperContent(context),
                        const SizedBox(height: 32),
                        _ResumoReservaCard(
                          sala: widget.sala,
                          date: selectedDate,
                          startTime: startTime,
                          endTime: endTime,
                          people: numberOfPeople,
                          total: _calculateTotal(),
                        ),
                      ],
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepperContent(BuildContext context) {
    const primaryColor = Color(0xFF4F46E5);
    final List<String> stepTitles = [
      'Tipo de Reserva',
      'Data e Horário',
      'Método de Pagamento',
      'Revisar e Confirmar'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Complete os detalhes abaixo para finalizar sua reserva',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Detalhes da Reserva', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              _CustomStepperIndicator(currentStep: _currentStep),
              const SizedBox(height: 24),
              Text(
                stepTitles[_currentStep],
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              _getStepContent(_currentStep),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Voltar'),
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_currentStep == 3 ? 'Confirmar Reserva' : 'Continuar'),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class _CustomStepperIndicator extends StatelessWidget {
  final int currentStep;
  const _CustomStepperIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4F46E5);
    return Row(
      children: List.generate(4, (index) {
        bool isActive = index <= currentStep;
        return Expanded(
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: isActive ? primaryColor : Colors.grey.shade300,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              if (index < 3)
                Expanded(
                  child: Container(
                    height: 2,
                    color: index < currentStep ? primaryColor : Colors.grey.shade300,
                  ),
                )
            ],
          ),
        );
      }),
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