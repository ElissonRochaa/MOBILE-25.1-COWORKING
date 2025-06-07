import 'package:flutter/material.dart';
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
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);
  int numberOfPeople = 1;
  String paymentMethod = 'credit';
  final paymentFormKey = GlobalKey<FormState>();
  bool acceptedTerms = false;

  double _calculateTotal() {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    final durationInHours = (endMinutes - startMinutes) / 60;
    return durationInHours > 0 ? durationInHours * widget.sala.precoHora : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar: ${widget.sala.nomeSala}'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 1,
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: () {
          final isLastStep = _currentStep == 3;
          if (isLastStep) {
            final isPaymentValid = (paymentMethod == 'credit' && (paymentFormKey.currentState?.validate() ?? false)) || paymentMethod == 'pix';
            if (isPaymentValid && acceptedTerms) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfirmationPage()));
            } else if (!acceptedTerms) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Você deve aceitar os termos e condições.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            setState(() => _currentStep += 1);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          } else {
            Navigator.of(context).pop();
          }
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          final isLastStep = _currentStep == 3;
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                    child: Text(isLastStep ? 'CONFIRMAR RESERVA' : 'CONTINUAR'),
                  ),
                ),
                if (_currentStep != 0) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      onPressed: details.onStepCancel,
                      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                      child: const Text('VOLTAR'),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Tipo de Reserva'),
            content: BookingStep1(
              bookingType: bookingType,
              onChanged: (value) => setState(() => bookingType = value),
            ),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Data e Horário'),
            content: BookingStep2(
              selectedDate: selectedDate,
              startTime: startTime,
              endTime: endTime,
              numberOfPeople: numberOfPeople,
              onDateChanged: (date) => setState(() => selectedDate = date),
              onStartTimeChanged: (time) => setState(() => startTime = time),
              onEndTimeChanged: (time) => setState(() => endTime = time),
              onPeopleChanged: (count) => setState(() => numberOfPeople = count),
            ),
             isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Pagamento'),
            content: BookingStep3(
              paymentMethod: paymentMethod,
              formKey: paymentFormKey,
              onChanged: (value) => setState(() => paymentMethod = value),
            ),
             isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Revisar e Confirmar'),
            content: BookingStep4(
              sala: widget.sala,
              selectedDate: selectedDate,
              startTime: startTime,
              endTime: endTime,
              numberOfPeople: numberOfPeople,
              paymentMethod: paymentMethod,
              total: _calculateTotal(),
              acceptedTerms: acceptedTerms,
              onTermsChanged: (value) => setState(() => acceptedTerms = value ?? false),
            ),
            isActive: _currentStep >= 3,
            state: _currentStep >= 3 ? StepState.complete : StepState.indexed,
          ),
        ],
      ),
    );
  }
}
