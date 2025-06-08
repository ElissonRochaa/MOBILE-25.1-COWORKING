import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:Wellspace/models/Sala.dart';
import 'package:Wellspace/viewmodels/SalaDetailViewModel.dart';
import 'package:Wellspace/viewmodels/SalaImagemViewModel.dart';
import 'package:Wellspace/views/ReservaEspacoPage.dart';

class Alugapage extends StatelessWidget {
  final String salaId;
  const Alugapage({super.key, required this.salaId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SalaDetailViewModel()),
        ChangeNotifierProvider(create: (_) => SalaImagemViewModel()),
      ],
      child: CoworkingPage(salaId: salaId),
    );
  }
}

class CoworkingPage extends StatefulWidget {
  final String salaId;
  const CoworkingPage({super.key, required this.salaId});

  @override
  State<CoworkingPage> createState() => _CoworkingPageState();
}

class _CoworkingPageState extends State<CoworkingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final salaDetailViewModel =
          Provider.of<SalaDetailViewModel>(context, listen: false);
      final salaImagemViewModel =
          Provider.of<SalaImagemViewModel>(context, listen: false);
      _fetchSalaData(salaDetailViewModel, salaImagemViewModel);
    });
  }

  Future<void> _fetchSalaData(SalaDetailViewModel salaDetailVM,
      SalaImagemViewModel salaImagemVM) async {
    await salaDetailVM.carregarSalaPorId(widget.salaId);
    if (salaDetailVM.sala != null && mounted) {
      await salaImagemVM.listarImagensPorSala(widget.salaId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer2<SalaDetailViewModel, SalaImagemViewModel>(
        builder: (context, salaDetailVM, salaImagemVM, child) {
          if (salaDetailVM.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF007BFF)));
          }
          if (salaDetailVM.sala == null) {
            return const Center(child: Text('Não foi possível carregar os dados da sala.', style: TextStyle(color: Colors.black87)));
          }
          final sala = salaDetailVM.sala!;
          final imagens = salaImagemVM.imagensCadastradas;

          return _PageContent(sala: sala, imagens: imagens);
        },
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  final Sala sala;
  final List<String> imagens;

  const _PageContent({required this.sala, required this.imagens});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240.0,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: const Color(0xFF007BFF),
            foregroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: _ImageGallery(imagens: imagens),
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
            ),
            actions: [
              IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
              IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _HeaderInfo(sala: sala),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: Colors.grey),
                  const SizedBox(height: 20),
                  _Section(title: 'Sobre este espaço', child: Text(sala.descricao, style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87))),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: Colors.grey),
                  const SizedBox(height: 20),
                  _Section(title: 'Comodidades', child: _AmenitiesGrid()),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: Colors.grey),
                  const SizedBox(height: 20),
                  _Section(title: 'Preços', child: _PricingInfo(precoHora: sala.precoHora)),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: sala.disponibilidadeSala.toUpperCase() == "DISPONIVEL"
                        ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReservaStepperScreen(sala: sala)))
                        : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007BFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      child: const Text('Reservar Agora'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(height: 1, color: Colors.grey),
                  const SizedBox(height: 20),
                  _Section(title: 'Horários de Funcionamento', child: _HoursInfo(sala: sala)),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: Colors.grey),
                  const SizedBox(height: 20),
                  _Section(title: 'Localização', child: _LocationMap()),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _ImageGallery extends StatefulWidget {
  final List<String> imagens;
  const _ImageGallery({required this.imagens});

  @override
  __ImageGalleryState createState() => __ImageGalleryState();
}

class __ImageGalleryState extends State<_ImageGallery> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imagens.isEmpty) {
      return Container(color: Colors.grey.shade200, child: const Center(child: Text('Nenhuma imagem')));
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: widget.imagens.length,
          itemBuilder: (context, index) {
            return Image.network(widget.imagens.elementAt(index), fit: BoxFit.cover, width: double.infinity);
          },
        ),
        if (widget.imagens.length > 1)
          Positioned(
            bottom: 12.0,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: widget.imagens.length,
              effect: WormEffect(
                dotColor: Colors.white.withOpacity(0.7),
                activeDotColor: const Color(0xFF007BFF),
                dotHeight: 9,
                dotWidth: 9,
              ),
            ),
          ),
      ],
    );
  }
}

class _HeaderInfo extends StatelessWidget {
  final Sala sala;
  const _HeaderInfo({required this.sala});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sala.nomeSala, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Icon(Icons.location_on_outlined, color: Colors.grey.shade600, size: 16),
            const SizedBox(width: 6),
            Expanded(child: Text("Av. Exemplo, 123 - Cidade", style: TextStyle(fontSize: 14, color: Colors.grey.shade600))),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            const Icon(Icons.star, color: Colors.amber, size: 18),
            const SizedBox(width: 4),
            const Text('4.8', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
            const SizedBox(width: 4),
            Text('(124 avaliações)', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
            const Spacer(),
            Text("Tamanho: ${sala.tamanho}", style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          ],
        ),
      ],
    );
  }
}

class _AmenitiesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> comodidades = [
      {'icon': Icons.wifi, 'label': 'Wi-Fi de Alta Velocidade'},
      {'icon': Icons.local_cafe, 'label': 'Café Gratuito'},
      {'icon': Icons.ac_unit, 'label': 'Ar Condicionado'},
      {'icon': Icons.print_outlined, 'label': 'Impressora'},
      {'icon': Icons.meeting_room_outlined, 'label': 'Salas de Reunião'},
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comodidades.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Row(
          children: [
            Icon(comodidades.elementAt(index)['icon'], color: const Color(0xFF007BFF), size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(comodidades.elementAt(index)['label'], style: const TextStyle(fontSize: 15, color: Colors.black87))),
          ],
        );
      },
    );
  }
}

class _PricingInfo extends StatelessWidget {
  final double precoHora;
  const _PricingInfo({required this.precoHora});

  @override
  Widget build(BuildContext context) {
    final double precoDia = precoHora * 8;
    final double precoSemana = precoDia * 5;

    final Map<String, dynamic> precos = {
      'Hora': precoHora,
      'Dia': precoDia,
      'Semana': precoSemana,
    };
    return Column(
      children: precos.entries.map((entry) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Text('Passe de ${entry.key}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
              const Spacer(),
              Text('R\$ ${entry.value.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _HoursInfo extends StatelessWidget {
  final Sala sala;
  const _HoursInfo({required this.sala});

  String _formatarDias(String dias) {
    switch (dias.toUpperCase()) {
      case 'SEGUNDA_A_SEXTA':
        return 'Segunda a Sexta';
      case 'TODOS_OS_DIAS':
        return 'Todos os dias';
      case 'FINS_DE_SEMANA':
        return 'Fins de Semana';
      default:
        return dias.replaceAll('_', ' ').split(RegExp(r'[,;]')).join(', ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.access_time_filled, color: const Color(0xFF007BFF), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatarDias(sala.disponibilidadeDiaSemana),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)
                ),
                const SizedBox(height: 4),
                Text(
                  '${sala.disponibilidadeInicio} às ${sala.disponibilidadeFim}',
                  style: const TextStyle(fontSize: 15, color: Colors.black87)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(Icons.map_outlined, size: 50, color: Colors.grey.shade600),
          ),
        ),
        const SizedBox(height: 12),
        const Text("Av. Exemplo, 123 - Próximo ao Metrô - Cidade", style: TextStyle(fontSize: 15, color: Colors.black87)),
      ],
    );
  }
}