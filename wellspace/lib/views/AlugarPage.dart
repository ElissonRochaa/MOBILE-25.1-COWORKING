import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:Wellspace/models/Sala.dart';
import 'package:Wellspace/viewmodels/SalaDetailViewModel.dart';
import 'package:Wellspace/viewmodels/SalaImagemViewModel.dart';
import 'package:Wellspace/views/ReservaEspacoPage.dart';
import 'package:Wellspace/views/widgets/sideMenu.dart';
import 'package:Wellspace/views/widgets/ThemeNotifer.dart';


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
      final salaDetailViewModel = Provider.of<SalaDetailViewModel>(context, listen: false);
      final salaImagemViewModel = Provider.of<SalaImagemViewModel>(context, listen: false);
      _fetchSalaData(salaDetailViewModel, salaImagemViewModel);
    });
  }

  Future<void> _fetchSalaData(SalaDetailViewModel salaDetailVM, SalaImagemViewModel salaImagemVM) async {
    await salaDetailVM.carregarSalaPorId(widget.salaId);
    if (salaDetailVM.sala != null && mounted) {
      await salaImagemVM.listarImagensPorSala(widget.salaId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        final pageGradient = LinearGradient(
          colors: isDarkMode
              ? [Colors.blueGrey[800]!, Colors.blueGrey[900]!]
              : [const Color(0xFF0066CC), const Color(0xFF3399FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
          appBar: isDesktop
              ? null
              : AppBar(
                  elevation: 0,
                  backgroundColor: isDarkMode ? Colors.blueGrey[800] : const Color(0xFF0066CC),
                  foregroundColor: Colors.white,
                  title: Consumer<SalaDetailViewModel>(
                    builder: (context, vm, child) => Text(vm.sala?.nomeSala ?? 'Detalhes da Sala'),
                  ),
                ),
          drawer: isDesktop
              ? null
              : Drawer(
                  child: Container(
                    decoration: BoxDecoration(gradient: pageGradient),
                    child: const SideMenu(), 
                  ),
                ),
          body: Consumer2<SalaDetailViewModel, SalaImagemViewModel>(
            builder: (context, salaDetailVM, salaImagemVM, child) {
              if (salaDetailVM.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (salaDetailVM.sala == null) {
                return const Center(child: Text('Sala não encontrada'));
              }
              final sala = salaDetailVM.sala!;
              
              if (isDesktop) {
                return Stack(
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(gradient: pageGradient),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 260, 
                          child: const SideMenu(), 
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildMainContent(context, sala, salaImagemVM.imagensCadastradas),
                              ),
                              SizedBox(
                                width: 400,
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: SingleChildScrollView(
                                    child: _BookingStickyCard(sala: sala),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return _buildMainContent(context, sala, salaImagemVM.imagensCadastradas, showBookingCard: true);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context, Sala sala, List<String> imageUrls, {bool showBookingCard = false}) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    sala.nomeSala,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _ImageGallery(imageUrls: imageUrls),
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderSection(sala: sala),
                const SizedBox(height: 40),
                _InfoSection(
                  title: 'Sobre este espaço',
                  icon: Icons.info_outline_rounded,
                  child: _CardContainer(
                    child: Text(
                      sala.descricao.isNotEmpty ? sala.descricao : 'Nenhuma descrição disponível.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            height: 1.6,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
               
                if(showBookingCard) ...[
                  const SizedBox(height: 40),
                  _BookingStickyCard(sala: sala),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _CardContainer extends StatelessWidget {
  final Widget child;
  const _CardContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> imageUrls;
  const _ImageGallery({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    
    if (imageUrls.isEmpty) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported_outlined,
                  size: 60,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhuma imagem disponível',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) => Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.error)),
              ),
            ),
            if (imageUrls.length > 1)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SmoothPageIndicator(
                      controller: pageController,
                      count: imageUrls.length,
                      effect: const ExpandingDotsEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 6,
                        activeDotColor: Colors.white,
                        dotColor: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatefulWidget {
  final Sala sala;
  const _HeaderSection({required this.sala});

  @override
  State<_HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<_HeaderSection> with TickerProviderStateMixin {
  bool _isFavorited = false;
  late AnimationController _favoriteController;
  late Animation<double> _favoriteAnimation;

  @override
  void initState() {
    super.initState();
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _favoriteAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _favoriteController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _favoriteController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() => _isFavorited = !_isFavorited);
    _favoriteController.forward().then((_) => _favoriteController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.sala.nomeSala,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Tamanho: ${widget.sala.tamanho}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ScaleTransition(
                    scale: _favoriteAnimation,
                    child: IconButton(
                      icon: Icon(
                        _isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorited ? Colors.redAccent : theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: _toggleFavorite,
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        shape: const CircleBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _InfoSection({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.onPrimaryContainer,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        child,
      ],
    );
  }
}

class _BookingStickyCard extends StatelessWidget {
  final Sala sala;
  const _BookingStickyCard({required this.sala});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAvailable = sala.disponibilidadeSala.toUpperCase() == "DISPONIVEL";
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor, width: 0.5)
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.monetization_on_outlined, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Preço por hora',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'R\$${sala.precoHora.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' / hora',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: isAvailable
                  ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservaStepperScreen(sala: sala),
                        ),
                      )
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(isAvailable ? Icons.calendar_today : Icons.block),
              label: Text(
                isAvailable ? 'Reservar Espaço' : 'Indisponível',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}