import 'package:Wellspace/viewmodels/SalaDetailViewModel.dart';
import 'package:Wellspace/viewmodels/SalaImagemViewModel.dart';
import 'package:Wellspace/views/widgets/sideMenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wellspace/models/Sala.dart';
import "package:Wellspace/views/ReservaEspacoPage.dart";

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
                                icon:
                                    const Icon(Icons.share, color: Colors.white),
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
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.7))),
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
                          color:
                              theme.colorScheme.onBackground.withOpacity(0.85))),
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
                              color: theme.colorScheme.outline
                                  .withOpacity(0.5))),
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
                        Text('A partir de',
                            style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7))),
                        const SizedBox(height: 4),
                        Text('R\$ ${sala.precoHora.toStringAsFixed(2)} / hora',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary)),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed:
                                sala.disponibilidadeSala.toUpperCase() ==
                                        "DISPONIVEL"
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ReservaEspacoScreen(
                                              sala: sala,
                                              imagens: salaImagemVM
                                                  .imagensCadastradas,
                                            ),
                                          ),
                                        );
                                      }
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              disabledBackgroundColor:
                                  theme.colorScheme.onSurface.withOpacity(0.12),
                              foregroundColor: theme.colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                            ),
                            child: Text(
                              sala.disponibilidadeSala.toUpperCase() ==
                                      "DISPONIVEL"
                                  ? 'Reservar este Espaço'
                                  : 'Indisponível no momento',
                              style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimary),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
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
}