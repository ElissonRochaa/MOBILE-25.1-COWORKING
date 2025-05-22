import 'package:Wellspace/viewmodels/SalaDetailViewModel.dart';
import 'package:Wellspace/viewmodels/SalaImagemViewModel.dart';
import 'package:Wellspace/views/widgets/sideMenu.dart'; // Seu SideMenu
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wellspace/models/Sala.dart'; // Seu modelo Sala

// Classe Alugapage agora aceita salaId e o passa para CoworkingPage
class Alugapage extends StatelessWidget {
  final String salaId;
  const Alugapage({super.key, required this.salaId});

  @override
  Widget build(BuildContext context) {
    return CoworkingPage(salaId: salaId);
  }
}

class CoworkingPage extends StatefulWidget {
  final String salaId;
  const CoworkingPage({super.key, required this.salaId});

  @override
  State<CoworkingPage> createState() => _CoworkingPageState();
}

class _CoworkingPageState extends State<CoworkingPage> {
  int _selectedTab = 0; // 0: Por Hora
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  int _people = 1;

  late SalaDetailViewModel _salaDetailViewModel;
  late SalaImagemViewModel _salaImagemViewModel;

  @override
  void initState() {
    super.initState();
    _salaDetailViewModel =
        Provider.of<SalaDetailViewModel>(context, listen: false);
    _salaImagemViewModel =
        Provider.of<SalaImagemViewModel>(context, listen: false);
    _fetchSalaData();
  }

  Future<void> _fetchSalaData() async {
    _salaDetailViewModel.limparDetalhesSala();
    await _salaDetailViewModel.carregarSalaPorId(widget.salaId);
    // Somente listar imagens se a sala for carregada com sucesso
    if (_salaDetailViewModel.sala != null) {
      await _salaImagemViewModel.listarImagensPorSala(widget.salaId);
    }
  }

  double get currentPricePerHour {
    final sala = _salaDetailViewModel.sala;
    // Usa precoHora do modelo Sala
    return sala?.precoHora ?? 0.0; // Retorna 0.0 se não disponível
  }

  double get totalPrice {
    if (_startTime == null || _endTime == null || currentPricePerHour == 0.0)
      return 0;
    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
    if (endMinutes <= startMinutes) return 0;
    final duration = (endMinutes - startMinutes) / 60.0;
    return (duration * currentPricePerHour * _people).clamp(0, double.infinity);
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime(bool isStart) async {
    final sala = _salaDetailViewModel.sala;
    TimeOfDay initialTime = const TimeOfDay(hour: 9, minute: 0);

    if (sala != null) {
      try {
        if (isStart && sala.disponibilidadeInicio.isNotEmpty) {
          final parts = sala.disponibilidadeInicio.split(':');
          initialTime =
              TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        } else if (!isStart && sala.disponibilidadeFim.isNotEmpty) {
          final parts = sala.disponibilidadeFim.split(':');
          initialTime =
              TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
      } catch (e) {
        // Usa o default se o parse falhar
      }
    }
    initialTime = isStart
        ? (_startTime ?? initialTime)
        : (_endTime ??
            TimeOfDay(hour: initialTime.hour + 1, minute: initialTime.minute));

    final time = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (time != null) {
      setState(() {
        if (isStart) {
          _startTime = time;
          if (_endTime != null) {
            final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
            final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
            if (startMinutes >= endMinutes) _endTime = null;
          }
        } else {
          if (_startTime != null) {
            final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
            final endMinutes = time.hour * 60 + time.minute;
            if (endMinutes > startMinutes) {
              _endTime = time;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'O horário de término deve ser após o horário de início.')),
              );
            }
          } else {
            _endTime = time;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<SalaDetailViewModel>(
          builder: (context, viewModel, child) {
            // Usa nomeSala do modelo Sala
            return Text(viewModel.sala?.nomeSala ?? 'WellSpace');
          },
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      drawer: SideMenu(),
      backgroundColor: Colors.grey.shade100,
      body: Consumer2<SalaDetailViewModel, SalaImagemViewModel>(
        builder: (context, salaDetailVM, salaImagemVM, child) {
          if (salaDetailVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (salaDetailVM.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Erro ao carregar dados da sala: ${salaDetailVM.errorMessage}\nPor favor, tente novamente.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red.shade700, fontSize: 16),
                ),
              ),
            );
          }
          if (salaDetailVM.sala == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off,
                        color: Colors.orange, size: 48),
                    const SizedBox(height: 16),
                    const Text(
                      'Detalhes da sala não encontrados.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ID da Sala: ${widget.salaId}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          final sala = salaDetailVM.sala!;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Início > Coworking > ${sala.nomeSala}',
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: salaImagemVM.imagensCadastradas.isNotEmpty
                            ? PageView.builder(
                                itemCount:
                                    salaImagemVM.imagensCadastradas.length,
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    salaImagemVM.imagensCadastradas[index],
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return const Center(
                                          child: Icon(
                                              Icons.broken_image_outlined,
                                              color: Colors.grey,
                                              size: 50));
                                    },
                                  );
                                },
                              )
                            : const Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8),
                                  Text('Nenhuma imagem disponível'),
                                ],
                              )),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.favorite_border,
                                  color: Colors.white),
                              onPressed: () {/* Lógica de favoritar */},
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.share, color: Colors.white),
                              onPressed: () {/* Lógica de compartilhar */},
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(sala.nomeSala,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  // O campo endereco não existe no modelo Sala fornecido.
                  // Você pode adicionar informações de localização se desejar, mas virão de outros campos ou serão fixas.
                  // Ex: Text('Localização: A ser definida', style: const TextStyle(color: Colors.grey)),
                  Row(
                    children: [
                      const Icon(Icons.square_foot_outlined,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Tamanho: ${sala.tamanho}',
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Campos de avaliação (avaliacaoMedia, numeroAvaliacoes) não existem. Removido.
                  const SizedBox(height: 16),
                  const Text('Sobre este espaço',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(sala.descricao.isNotEmpty
                      ? sala.descricao
                      : 'Nenhuma descrição disponível.'),
                  const SizedBox(height: 16),
                  _buildScheduleCard(sala), // Passar o objeto sala inteiro
                  const SizedBox(height: 16),
                  const Text('Localização no Mapa',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                      height: 150,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade400)),
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map_outlined,
                            size: 40,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text('Integração com mapa pendente',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      )),
                  const SizedBox(height: 16),
                  const Text('Preços',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  // ToggleButtons para dia/mês não fazem sentido sem precoPorDia/Mes
                  // Mantendo apenas a opção "Por Hora"
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 6)
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Por hora',
                            style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 4),
                        Text('R\$ ${sala.precoHora.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF004AAD))),
                        const SizedBox(height: 4),
                        // O campo disponibilidadeSala pode ser usado aqui
                        Text('Status: ${sala.disponibilidadeSala}',
                            style: TextStyle(
                                fontSize: 12,
                                color: sala.disponibilidadeSala.toUpperCase() ==
                                        "DISPONIVEL"
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _buildReservationForm(sala),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Card de Comparativo de Preços removido pois não há precoDia/Mes
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleCard(Sala sala) {
    final diasDaSemanaOrdem = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom'];
    final diasDaSemanaNomes = {
      'Seg': 'Segunda',
      'Ter': 'Terça',
      'Qua': 'Quarta',
      'Qui': 'Quinta',
      'Sex': 'Sexta',
      'Sab': 'Sábado',
      'Dom': 'Domingo'
    };

    // Parse da string disponibilidadeDiaSemana (ex: "Seg,Ter,Qua")
    final diasDisponiveis = sala.disponibilidadeDiaSemana
        .split(',')
        .map((dia) => dia.trim())
        .where((dia) => dia.isNotEmpty)
        .toSet();

    final horarioFuncionamento = (sala.disponibilidadeInicio.isNotEmpty &&
            sala.disponibilidadeFim.isNotEmpty)
        ? '${sala.disponibilidadeInicio} - ${sala.disponibilidadeFim}'
        : 'Não especificado';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Horários de Funcionamento",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ...diasDaSemanaOrdem.map((diaAbrev) {
          final nomeCompleto = diasDaSemanaNomes[diaAbrev] ?? diaAbrev;
          final disponivelNesteDia = diasDisponiveis.contains(diaAbrev);
          final horarioExibicao =
              disponivelNesteDia ? horarioFuncionamento : 'Fechado';

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(nomeCompleto),
                Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 16,
                        color: disponivelNesteDia
                            ? Colors.black54
                            : Colors.red.shade300),
                    const SizedBox(width: 4),
                    Text(horarioExibicao,
                        style: TextStyle(
                            color: disponivelNesteDia
                                ? Colors.black
                                : Colors.red)),
                  ],
                )
              ],
            ),
          );
        }).toList(),
      ]),
    );
  }

  Widget _buildReservationForm(Sala sala) {
    bool podeReservar =
        sala.disponibilidadeSala.toUpperCase() == "DISPONIVEL" &&
            _selectedDate != null &&
            _startTime != null &&
            _endTime != null &&
            totalPrice > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickDate,
          child: AbsorbPointer(
            child: TextFormField(
              key: ValueKey(
                  'date-${_selectedDate?.toIso8601String()}'), // Para forçar rebuild
              initialValue: _selectedDate == null
                  ? null
                  : '${_selectedDate!.day.toString().padLeft(2, '0')}/'
                      '${_selectedDate!.month.toString().padLeft(2, '0')}/'
                      '${_selectedDate!.year}',
              decoration: InputDecoration(
                hintText: 'Data',
                labelText: 'Data',
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
                    key: ValueKey('start-${_startTime?.format(context)}'),
                    initialValue: _startTime?.format(context),
                    decoration: InputDecoration(
                      hintText: 'Início',
                      labelText: 'Início',
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
                    key: ValueKey('end-${_endTime?.format(context)}'),
                    initialValue: _endTime?.format(context),
                    decoration: InputDecoration(
                      hintText: 'Término',
                      labelText: 'Término',
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
          initialValue: _people.toString(),
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
            onPressed: podeReservar
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Reserva para ${sala.nomeSala} (${sala.disponibilidadeSala}) solicitada! Total: R\$${totalPrice.toStringAsFixed(2)}')),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF004AAD),
              disabledBackgroundColor: Colors.grey.shade400,
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
