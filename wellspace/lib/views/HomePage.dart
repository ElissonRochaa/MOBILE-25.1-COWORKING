import 'package:Wellspace/models/Sala.dart';
import 'package:Wellspace/viewmodels/SalaListViewModel.dart';
import 'package:Wellspace/views/widgets/ThemeNotifer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/widgets/sideMenu.dart';
import 'package:Wellspace/services/SalaImagesService.dart';

final themeNotifier = ThemeNotifier();

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(
        "HomePage: Reconstruindo. Brilho atual do tema via Theme.of(context): ${Theme.of(context).brightness}");

    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: const Text('Início'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            HeroSection(),
            SizedBox(height: 24),
            FeaturedSpacesSection(),
            SizedBox(height: 24),
            HowItWorksSection(),
            SizedBox(height: 24),
            CTABanner(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.blueGrey[700]!, Colors.blueGrey[900]!]
              : [const Color(0xFF0066CC), const Color(0xFF3399FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Encontre o espaço de trabalho perfeito para você',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Milhares de espaços de coworking disponíveis para reserva imediata',
            style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.white70,
                fontSize: 16),
          ),
          const SizedBox(height: 24),
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Buscar espaço ideal',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/espacos');
                          },
                          child: const Text('Buscar'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, '/cadastroSala'),
                      child: const Text('Cadastre sua sala'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeaturedSpacesSection extends StatefulWidget {
  const FeaturedSpacesSection({Key? key}) : super(key: key);

  @override
  _FeaturedSpacesSectionState createState() => _FeaturedSpacesSectionState();
}

class _FeaturedSpacesSectionState extends State<FeaturedSpacesSection> {
  final SalaListViewModel salaListViewModel = SalaListViewModel();

  @override
  void initState() {
    super.initState();
    salaListViewModel.carregarSalas().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Sala> destaques = salaListViewModel.salas.length > 5
        ? salaListViewModel.salas.sublist(0, 5)
        : salaListViewModel.salas;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Espaços em Destaque',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/espacos');
                  },
                  child: const Text('Ver todos')),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 340,
            child: salaListViewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : destaques.isEmpty
                    ? const Center(
                        child: Text('Nenhum espaço em destaque encontrado.'))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: destaques.length,
                        itemBuilder: (context, index) {
                          final espaco = destaques[index];
                          return SizedBox(
                            width: 300,
                            child: SalaCard(
                              key: ValueKey(espaco.id),
                              sala: espaco,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: const [
          Text(
            'Como Funciona',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _StepItem(
                  icon: Icons.search,
                  title: 'Busque',
                  description:
                      'Encontre o espaço ideal para suas necessidades.',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _StepItem(
                  icon: Icons.calendar_today,
                  title: 'Reserve',
                  description:
                      'Escolha a data e horário e faça sua reserva em poucos cliques.',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _StepItem(
                  icon: Icons.work,
                  title: 'Trabalhe',
                  description:
                      'Aproveite um ambiente profissional e produtivo.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _StepItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: isDark
              ? Theme.of(context).colorScheme.secondaryContainer
              : Colors.blue.shade50,
          child: Icon(icon,
              size: 30,
              color: isDark
                  ? Theme.of(context).colorScheme.onSecondaryContainer
                  : Colors.blue),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(description,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[400] : Colors.black54)),
      ],
    );
  }
}

class CTABanner extends StatelessWidget {
  const CTABanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark
            ? Theme.of(context).colorScheme.primaryContainer
            : Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Pronto para encontrar seu espaço ideal?',
            style: TextStyle(
                color: isDark
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Milhares de profissionais já encontraram o espaço perfeito para trabalhar. Junte-se a eles!',
            style: TextStyle(
                color: isDark
                    ? Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withOpacity(0.8)
                    : Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/espacos');
            },
            child: const Text('Explorar Espaços'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDark ? Theme.of(context).colorScheme.surface : Colors.white,
              foregroundColor: isDark
                  ? Theme.of(context).colorScheme.onSurface
                  : Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class SalaCard extends StatefulWidget {
  final Sala sala;

  const SalaCard({super.key, required this.sala});

  @override
  State<SalaCard> createState() => _SalaCardState();
}

class _SalaCardState extends State<SalaCard> {
  String? imageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImagem();
  }

  @override
  void didUpdateWidget(covariant SalaCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sala.id != oldWidget.sala.id) {
      _loadImagem();
    }
  }

  Future<void> _loadImagem() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      imageUrl = null;
    });
    try {
      final String idParaServico = widget.sala.id.toString();

      final List<String> urlsRecebidas =
          await SalaImagemService.listarImagensPorSala(idParaServico);

      if (mounted) {
        setState(() {
          if (urlsRecebidas.isNotEmpty) {
            imageUrl = urlsRecebidas.first;
          } else {
            imageUrl = null;
          }

          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      if (mounted) {
        setState(() {
          isLoading = false;
          imageUrl = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/alugar', arguments: widget.sala.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : imageUrl != null && imageUrl!.isNotEmpty
                          ? Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey[500],
                                  ),
                                );
                              },
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Icon(
                                Icons.meeting_room_outlined,
                                size: 50,
                                color: Colors.grey[500],
                              ),
                            ),
                ),
                if (widget.sala.disponibilidadeSala.isNotEmpty)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.sala.disponibilidadeSala,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sala.nomeSala,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.sala.descricao,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.aspect_ratio_outlined,
                          size: 15,
                          color: isDark ? Colors.grey[400] : Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        widget.sala.tamanho,
                        style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                            fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 16,
                          color: isDark ? Colors.grey[400] : Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${widget.sala.disponibilidadeDiaSemana} (${widget.sala.disponibilidadeInicio} - ${widget.sala.disponibilidadeFim})',
                          style: TextStyle(
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[700],
                              fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'R\$ ${widget.sala.precoHora.toStringAsFixed(2)}/hora',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
