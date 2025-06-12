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
    final theme = Theme.of(context);

    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      final isPaymentValid = (paymentMethod == 'credit' &&
              (paymentFormKey.currentState?.validate() ?? false)) ||
          paymentMethod == 'pix';
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
          SnackBar(
            content: const Text(
                'Você deve aceitar os termos e condições para continuar.'),
            backgroundColor: theme.colorScheme.error,
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
        return BookingStep1(
            bookingType: bookingType,
            onChanged: (value) => setState(() => bookingType = value));
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
          onTermsChanged: (value) =>
              setState(() => acceptedTerms = value ?? false),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Reservar Espaço'),
        elevation: 1,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
              color: theme.colorScheme.outline.withOpacity(0.3), height: 1.0),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: _buildStepperContent(context, theme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepperContent(BuildContext context, ThemeData theme) {
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
          style: theme.textTheme.bodyLarge
              ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Detalhes da Reserva',
                  style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface)),
              const SizedBox(height: 24),
              _CustomStepperIndicator(currentStep: _currentStep, theme: theme),
              const SizedBox(height: 24),
              Text(
                stepTitles[_currentStep],
                style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 16),
              _getStepContent(_currentStep),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: theme.colorScheme.outline),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        foregroundColor: theme.colorScheme.onSurface,
                      ),
                      child: Text(_currentStep == 0 ? 'Cancelar' : 'Voltar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _nextStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        _currentStep == 3 ? 'Confirmar Reserva' : 'Continuar',
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
  final ThemeData theme;
  const _CustomStepperIndicator(
      {required this.currentStep, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (index) {
        bool isActive = index <= currentStep;
        bool isCompleted = index < currentStep;

        Color circleColor = isActive
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceVariant;
        Color textColor = isActive
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurfaceVariant;
        Color lineColor = isCompleted
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceVariant;

        return Expanded(
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: circleColor,
                child: Text(
                  '${index + 1}',
                  style:
                      TextStyle(color: textColor, fontWeight: FontWeight.bold),
                ),
              ),
              if (index < 3)
                Expanded(
                  child: Container(
                    height: 2,
                    color: lineColor,
                  ),
                )
            ],
          ),
        );
      }),
    );
  }
}
