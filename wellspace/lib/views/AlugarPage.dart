import 'package:flutter/material.dart';

class Alugapage extends StatelessWidget {
  const Alugapage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CoworkingPage(),
    );
  }
}

class CoworkingPage extends StatefulWidget {
  const CoworkingPage({super.key});

  @override
  State<CoworkingPage> createState() => _CoworkingPageState();
}

class _CoworkingPageState extends State<CoworkingPage> {
  int _selectedTab = 0;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  int _people = 1;
  final pricePerHour = 25.0;

  double get totalPrice {
    if (_startTime == null || _endTime == null) return 0;
    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
    final duration = (endMinutes - startMinutes) / 60.0;
    return (duration * pricePerHour * _people).clamp(0, double.infinity);
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime(bool isStart) async {
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (time != null) {
      setState(() {
        if (isStart) {
          _startTime = time;
        } else {
          _endTime = time;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Início > Coworking > Coworking Central',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Stack(
                children: [
                  Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(child: Text('Carrossel de imagens')),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              const Text('Coworking Central',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                children: const [
                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text('Open Space - Centro, São Paulo',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  Icon(Icons.star, color: Colors.amber),
                  Text(' 4.8 (120+ avaliações)')
                ],
              ),
              const SizedBox(height: 16),
              const Text('Sobre este espaço',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Text(
                  'Espaço moderno e bem localizado no centro da cidade. Ideal para freelancers e profissionais independentes.'),
              const SizedBox(height: 16),
              _buildScheduleCard(),
              const SizedBox(height: 16),
              const Text('Localização',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                height: 150,
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: const Text('Mapa do Google será integrado aqui'),
              ),
              const SizedBox(height: 16),
              const Text('Preços',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ToggleButtons(
                isSelected: [
                  _selectedTab == 0,
                  _selectedTab == 1,
                  _selectedTab == 2
                ],
                onPressed: (index) => setState(() => _selectedTab = index),
                children: const [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Por hora')),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Por dia')),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Por mês')),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Por hora',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 4),
                    const Text('R\$ 25',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF004AAD))),
                    const SizedBox(height: 4),
                    const Text('Atualizado em abr de 2025',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 16),
                    _buildReservationForm(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Comparativo de Preços',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Por hora:'),
                        Text('R\$ 25'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Por dia:'),
                        Text('R\$ 100 (17% de economia)'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Por mês:'),
                        Text('R\$ 1100 (72% de economia)'),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCard() {
    const dias = [
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo'
    ];
    const horarios = [
      '08:00 - 20:00',
      '08:00 - 20:00',
      '08:00 - 20:00',
      '08:00 - 20:00',
      '08:00 - 20:00',
      '09:00 - 16:00',
      'Fechado'
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
            dias.length,
            (i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dias[i]),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 4),
                          Text(horarios[i],
                              style: TextStyle(
                                  color: horarios[i] == 'Fechado'
                                      ? Colors.red
                                      : Colors.black)),
                        ],
                      )
                    ],
                  ),
                )),
      ),
    );
  }

  Widget _buildReservationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickDate,
          child: AbsorbPointer(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: _selectedDate == null
                    ? 'Data'
                    : '${_selectedDate!.day.toString().padLeft(2, '0')}/'
                        '${_selectedDate!.month.toString().padLeft(2, '0')}/'
                        '${_selectedDate!.year}',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _pickTime(true),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: _startTime == null
                          ? 'Início'
                          : _startTime!.format(context),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => _pickTime(false),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: _endTime == null
                          ? 'Término'
                          : _endTime!.format(context),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: '1',
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Número de Pessoas',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: (val) => setState(() => _people = int.tryParse(val) ?? 1),
        ),
        const SizedBox(height: 16),
        Text('Total: R\$ ${totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF004AAD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Reservar Agora',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
