import 'package:flutter/material.dart';
import 'package:Wellspace/models/Sala.dart';
import 'package:Wellspace/views/widgets/BookingStep1.dart';
import 'package:Wellspace/views/widgets/BookingStep2.dart';
import 'package:Wellspace/views/widgets/BookingStep3.dart';
import 'package:Wellspace/views/widgets/BookingStep4.dart';
import 'package:Wellspace/views/TelaDeConfirmacao.dart';

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
      final isPaymentValid = (paymentMethod == 'credit' && (paymentFormKey.currentState?.validate() ?? false)) || paymentMethod == 'pix';
      if (isPaymentValid && acceptedTerms) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TelaConfirmacaoReserva(
              sala: widget.sala,
              selectedDate: selectedDate,
              startTime: startTime,
              endTime: endTime,
              numberOfPeople: numberOfPeople,
              total: _calculateTotal(),
            ),
          ),
        );
      } else if (!acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Você deve aceitar os termos e condições para continuar.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.of(context).pop();
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
    
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: _buildStepperContent(context),
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
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Voltar'),
                      ),
                    ),
                  if (_currentStep > 0)
                    const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                 
                      child: Text(
                        _currentStep == 3 ? 'Revisar Reserva' : 'Continuar',
                        textAlign: TextAlign.center,
                      ),
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

