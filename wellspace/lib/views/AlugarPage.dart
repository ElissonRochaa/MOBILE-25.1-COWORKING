import 'package:Wellspace/viewmodels/SalaDetailViewModel.dart';
import 'package:Wellspace/viewmodels/SalaImagemViewModel.dart';
import 'package:Wellspace/views/widgets/sideMenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wellspace/models/Sala.dart';

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
  int _selectedTab = 0;
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
    if (_salaDetailViewModel.sala != null && mounted) {
      await _salaImagemViewModel.listarImagensPorSala(widget.salaId);
    }
  }

  double get currentPricePerHour {
    final sala = _salaDetailViewModel.sala;
    return sala?.precoHora ?? 0.0;
  }

  double get totalPrice {
    if (_startTime == null || _endTime == null || currentPricePerHour == 0.0) {
      return 0;
    }
    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
    if (endMinutes <= startMinutes) return 0;
    final duration = (endMinutes - startMinutes) / 60.0;
    return (duration * currentPricePerHour * _people).clamp(0, double.infinity);
  }

  Future<void> _pickDate() async {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: colorScheme.copyWith(
              primary: colorScheme.primary,
              onPrimary: colorScheme.onPrimary,
              surface: colorScheme.surface,
              onSurface: colorScheme.onSurface,
            ),
            dialogBackgroundColor: theme.dialogBackgroundColor,
          ),
          child: child!,
        );
      },
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickTime(bool isStart) async {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
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
      } catch (e) {}
    }
    initialTime = isStart
        ? (_startTime ?? initialTime)
        : (_endTime ??
            TimeOfDay(hour: initialTime.hour + 1, minute: initialTime.minute));

    final time = await showTimePicker(
        context: context,
        initialTime: initialTime,
        builder: (context, child) {
          return Theme(
            data: theme.copyWith(
              colorScheme: colorScheme.copyWith(
                primary: colorScheme.primary,
                onPrimary: colorScheme.onPrimary,
                surface: colorScheme.surface,
                onSurface: colorScheme.onSurface,
              ),
              timePickerTheme: theme.timePickerTheme.copyWith(
                backgroundColor: theme.dialogBackgroundColor,
              ),
            ),
            child: child!,
          );
        });

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
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Consumer<SalaDetailViewModel>(
          builder: (context, viewModel, child) {
            return Text(viewModel.sala?.nomeSala ?? 'WellSpace');
          },
        ),
      ),
      drawer: SideMenu(),
      backgroundColor: theme.colorScheme.background,
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
                  style:
                      TextStyle(color: theme.colorScheme.error, fontSize: 16),
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
                    Icon(Icons.search_off,
                        color: theme.colorScheme.secondary, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Detalhes da sala não encontrados.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18, color: theme.colorScheme.onBackground),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ID da Sala: ${widget.salaId}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurface.withOpacity(0.6)),
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
                      style: TextStyle(
                          color: theme.textTheme.bodySmall?.color ??
                              theme.colorScheme.onSurface.withOpacity(0.6))),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: salaImagemVM.imagensCadastradas.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: PageView.builder(
                                  itemCount:
                                      salaImagemVM.imagensCadastradas.length,
                                  itemBuilder: (context, index) {
                                    return Image.network(
                                      salaImagemVM.imagensCadastradas[index],
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
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
                                        return Center(
                                            child: Icon(
                                                Icons.broken_image_outlined,
                                                color: theme.colorScheme
                                                    .onSurfaceVariant,
                                                size: 50));
                                      },
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 50,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Nenhuma imagem disponível',
                                      style: TextStyle(
                                          color: theme
                                              .colorScheme.onSurfaceVariant)),
                                ],
                              )),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.favorite_border,
                                    color: Colors.white),
                                onPressed: () {},
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                              ),
                              IconButton(
                                icon: const Icon(Icons.share,
                                    color: Colors.white),
                                onPressed: () {},
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(sala.nomeSala,
                      style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onBackground)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.square_foot_outlined,
                          size: 16,
                          color: theme.colorScheme.onSurface.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Text('Tamanho: ${sala.tamanho}',
                          style: TextStyle(
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.7))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Sobre este espaço',
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onBackground)),
                  const SizedBox(height: 4),
                  Text(
                      sala.descricao.isNotEmpty
                          ? sala.descricao
                          : 'Nenhuma descrição disponível.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onBackground
                              .withOpacity(0.85))),
                  const SizedBox(height: 16),
                  _buildScheduleCard(context, theme, sala),
                  const SizedBox(height: 16),
                  Text('Localização no Mapa',
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onBackground)),
                  Container(
                      height: 150,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color:
                                  theme.colorScheme.outline.withOpacity(0.5))),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map_outlined,
                            size: 40,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 8),
                          Text('Integração com mapa pendente',
                              style: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      )),
                  const SizedBox(height: 16),
                  Text('Preços',
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onBackground)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor
                              .withOpacity(isDarkMode ? 0.3 : 0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Por hora',
                            style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7))),
                        const SizedBox(height: 4),
                        Text('R\$ ${sala.precoHora.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary)),
                        const SizedBox(height: 4),
                        Text('Status: ${sala.disponibilidadeSala}',
                            style: TextStyle(
                                fontSize: 12,
                                color: sala.disponibilidadeSala.toUpperCase() ==
                                        "DISPONIVEL"
                                    ? (isDarkMode
                                        ? Colors.greenAccent.shade400
                                        : Colors.green.shade700)
                                    : (isDarkMode
                                        ? Colors.redAccent.shade200
                                        : Colors.red.shade700),
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _buildReservationForm(context, theme, sala),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleCard(BuildContext context, ThemeData theme, Sala sala) {
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

    final diasDisponiveis = sala.disponibilidadeDiaSemana
        .split(',')
        .map((dia) => dia.trim())
        .where((dia) => dia.isNotEmpty)
        .toSet();

    final horarioFuncionamento = (sala.disponibilidadeInicio.isNotEmpty &&
            sala.disponibilidadeFim.isNotEmpty)
        ? '${sala.disponibilidadeInicio} - ${sala.disponibilidadeFim}'
        : 'Não especificado';

    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: theme.shadowColor.withOpacity(isDarkMode ? 0.25 : 0.08),
              blurRadius: 4,
              offset: const Offset(0, 1))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Horários de Funcionamento",
            style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface)),
        const SizedBox(height: 8),
        ...diasDaSemanaOrdem.map((diaAbrev) {
          final nomeCompleto = diasDaSemanaNomes[diaAbrev] ?? diaAbrev;
          final disponivelNesteDia = diasDisponiveis.contains(diaAbrev);
          final horarioExibicao =
              disponivelNesteDia ? horarioFuncionamento : 'Fechado';

          Color statusColor = disponivelNesteDia
              ? theme.colorScheme.onSurface
              : theme.colorScheme.error;
          Color iconColor = disponivelNesteDia
              ? theme.colorScheme.onSurfaceVariant
              : theme.colorScheme.error.withOpacity(0.7);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(nomeCompleto,
                    style: TextStyle(color: theme.colorScheme.onSurface)),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: iconColor),
                    const SizedBox(width: 4),
                    Text(horarioExibicao, style: TextStyle(color: statusColor)),
                  ],
                )
              ],
            ),
          );
        }).toList(),
      ]),
    );
  }

  Widget _buildReservationForm(
      BuildContext context, ThemeData theme, Sala sala) {
    bool podeReservar =
        sala.disponibilidadeSala.toUpperCase() == "DISPONIVEL" &&
            _selectedDate != null &&
            _startTime != null &&
            _endTime != null &&
            totalPrice > 0;

    InputDecorationTheme inputDecorationTheme = theme.inputDecorationTheme;
    InputDecoration formFieldDecoration(String label, String hint,
        {Widget? suffixIcon}) {
      return InputDecoration(
        labelText: label,
        hintText: hint,
        border: inputDecorationTheme.border ??
            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: inputDecorationTheme.enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: theme.colorScheme.outline.withOpacity(0.7)),
            ),
        focusedBorder: inputDecorationTheme.focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: theme.colorScheme.primary, width: 1.5),
            ),
        labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        hintStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7)),
        suffixIcon: suffixIcon != null
            ? IconTheme(
                data: IconThemeData(color: theme.colorScheme.onSurfaceVariant),
                child: suffixIcon)
            : null,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickDate,
          child: AbsorbPointer(
            child: TextFormField(
              key: ValueKey('date-${_selectedDate?.toIso8601String()}'),
              initialValue: _selectedDate == null
                  ? null
                  : '${_selectedDate!.day.toString().padLeft(2, '0')}/'
                      '${_selectedDate!.month.toString().padLeft(2, '0')}/'
                      '${_selectedDate!.year}',
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: formFieldDecoration('Data', 'Selecione a data',
                  suffixIcon: const Icon(Icons.calendar_today)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _pickTime(true),
                child: AbsorbPointer(
                  child: TextFormField(
                    key: ValueKey('start-${_startTime?.format(context)}'),
                    initialValue: _startTime?.format(context),
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: formFieldDecoration('Início', 'HH:MM'),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => _pickTime(false),
                child: AbsorbPointer(
                  child: TextFormField(
                    key: ValueKey('end-${_endTime?.format(context)}'),
                    initialValue: _endTime?.format(context),
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: formFieldDecoration('Término', 'HH:MM'),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: _people.toString(),
          keyboardType: TextInputType.number,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration:
              formFieldDecoration('Número de Pessoas', 'Quantas pessoas?'),
          onChanged: (val) => setState(() => _people = int.tryParse(val) ?? 1),
        ),
        const SizedBox(height: 16),
        Text('Total: R\$ ${totalPrice.toStringAsFixed(2)}',
            style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground)),
        const SizedBox(height: 12),
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
              backgroundColor: theme.colorScheme.primary,
              disabledBackgroundColor:
                  theme.colorScheme.onSurface.withOpacity(0.12),
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Text('Reservar Agora',
                style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary)),
          ),
        )
      ],
    );
  }
}
