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
      body: Consumer2<SalaDetailViewModel, SalaImagemViewModel>(
        builder: (context, salaDetailVM, salaImagemVM, child) {
          final theme = Theme.of(context);

          if (salaDetailVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (salaDetailVM.sala == null) {
            return Center(
              child: Text('Não foi possível carregar os dados da sala.',
                  style: TextStyle(color: theme.colorScheme.error)),
            );
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
      backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      body: CustomScrollView(
        slivers: [
          _CustomSliverAppBar(imagens: imagens),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _HeaderInfo(sala: sala),
                _InfoCard(
                  title: 'Sobre este espaço',
                  icon: Icons.info_outline,
                  child: Text(
                    sala.descricao.isNotEmpty
                        ? sala.descricao
                        : "Nenhuma descrição disponível.",
                    style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                        color: theme.colorScheme.onSurface.withOpacity(0.85)),
                  ),
                ),
                _InfoCard(
                  title: 'Comodidades',
                  icon: Icons.widgets_outlined,
                  child: _AmenitiesGrid(),
                ),
                _InfoCard(
                  title: 'Horário de Funcionamento',
                  icon: Icons.access_time_rounded,
                  child: _HoursInfo(sala: sala),
                ),
                _InfoCard(
                  title: 'Localização',
                  icon: Icons.location_on_outlined,
                  child: _LocationMap(),
                ),
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _StickyBookingBar(sala: sala),
    );
  }
}

class _CustomSliverAppBar extends StatelessWidget {
  final List<String> imagens;
  const _CustomSliverAppBar({required this.imagens});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 300.0,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: 2,
      shadowColor: theme.shadowColor.withOpacity(0.1),
      flexibleSpace: FlexibleSpaceBar(
        background: _ImageGallery(imagens: imagens),
        stretchModes: const [StretchMode.zoomBackground],
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> imagens;
  const _ImageGallery({required this.imagens});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    final theme = Theme.of(context);

    if (imagens.isEmpty) {
      return Container(
          color: theme.colorScheme.surfaceVariant,
          child: Center(
              child: Icon(Icons.business_rounded,
                  size: 80,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5))));
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: pageController,
          itemCount: imagens.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    opaque: false,
                    barrierColor: Colors.black,
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return FullScreenImageViewer(
                        imageUrls: imagens,
                        initialIndex: index,
                      );
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              },
              child: Image.network(
                imagens.elementAt(index),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(Icons.broken_image, color: Colors.white70)),
              ),
            );
          },
        ),
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                stops: const [0.0, 0.4],
              ),
            ),
          ),
        ),
        if (imagens.length > 1)
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: pageController,
                count: imagens.length,
                effect: ScrollingDotsEffect(
                  dotColor: Colors.white.withOpacity(0.6),
                  activeDotColor: theme.colorScheme.primary,
                  dotHeight: 8,
                  dotWidth: 8,
                ),
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sala.nomeSala,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.amber.withOpacity(0.2)
                    : Colors.amber.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.star_rounded,
                      color: Colors.amber.shade600, size: 16),
                  const SizedBox(width: 4),
                  Text('4.8 (124)',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: isDarkMode
                              ? Colors.amber.shade200
                              : Colors.amber.shade900)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.location_on_outlined,
                color: theme.colorScheme.primary, size: 16),
            const SizedBox(width: 4),
            Expanded(
                child: Text("Av. Exemplo, 123",
                    style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600))),
          ],
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _InfoCard(
      {required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DefaultTextStyle(
              style: theme.textTheme.bodyMedium!
                  .copyWith(color: theme.colorScheme.onSurface),
              child: child),
        ],
      ),
    );
  }
}

class _AmenitiesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final comodidades = [
      {'icon': Icons.wifi, 'label': 'Wi-Fi Fibra'},
      {'icon': Icons.local_cafe_rounded, 'label': 'Café e Água'},
      {'icon': Icons.ac_unit_rounded, 'label': 'Ar Condicionado'},
      {'icon': Icons.print_rounded, 'label': 'Impressora'},
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comodidades.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        return Row(
          children: [
            Icon(comodidades[index]['icon'] as IconData,
                color: theme.colorScheme.primary, size: 22),
            const SizedBox(width: 12),
            Expanded(
                child: Text(
              comodidades[index]['label'] as String,
              style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface),
            )),
          ],
        );
      },
    );
  }
}

class _HoursInfo extends StatelessWidget {
  final Sala sala;
  const _HoursInfo({required this.sala});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dias de semana',
                  style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface)),
              const SizedBox(height: 4),
              Text(sala.disponibilidadeDiaSemana.replaceAll('_', ' '),
                  style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7))),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Horário',
                  style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface)),
              const SizedBox(height: 4),
              Text('${sala.disponibilidadeInicio} - ${sala.disponibilidadeFim}',
                  style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7))),
            ],
          ),
        ),
      ],
    );
  }
}

class _LocationMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(Icons.map_outlined,
                  size: 50, color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text("Av. Exemplo, 123 - Próximo ao Metrô",
            style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.8))),
      ],
    );
  }
}

class _StickyBookingBar extends StatelessWidget {
  final Sala sala;
  const _StickyBookingBar({required this.sala});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12).copyWith(
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border(
            top: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.2), width: 1)),
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'R\$ ${sala.precoHora.toStringAsFixed(2)}',
                style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface),
              ),
              Text('/ hora',
                  style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.7))),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: sala.disponibilidadeSala.toUpperCase() == "DISPONIVEL"
                  ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ReservaStepperScreen(sala: sala)))
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                disabledBackgroundColor:
                    theme.colorScheme.onSurface.withOpacity(0.12),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text('Reservar Agora'),
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return InteractiveViewer(
                panEnabled: true,
                minScale: 1.0,
                maxScale: 4.0,
                child: Center(
                  child: Image.network(
                    widget.imageUrls[index],
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: Colors.white,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image,
                                color: Colors.white, size: 64),
                            SizedBox(height: 16),
                            Text('Erro ao carregar imagem',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 20.0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentIndex + 1} / ${widget.imageUrls.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
