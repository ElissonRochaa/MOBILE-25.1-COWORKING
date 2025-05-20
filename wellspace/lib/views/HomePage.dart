import 'dart:convert';
import 'package:Wellspace/models/Sala.dart';
import 'package:Wellspace/viewmodels/SalaListViewModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../views/widgets/sideMenu.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0066CC), Color(0xFF3399FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Encontre o espaço de trabalho perfeito para você',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Milhares de espaços de coworking disponíveis para reserva imediata',
            style: TextStyle(color: Colors.white70, fontSize: 16),
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
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
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
      setState(() {}); // Atualiza a UI após carregar as salas
    });
  }

  @override
  Widget build(BuildContext context) {
    // Seleciona as primeiras 5 salas como destaques (você pode adaptar esse filtro)
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
              const Text(
                'Espaços em Destaque',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(onPressed: () {}, child: const Text('Ver todos')),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 260,
            child: salaListViewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: destaques.length,
                    itemBuilder: (context, index) {
                      final espaco = destaques[index];
                      return SpaceCard(
                        nome: espaco.nomeSala,
                        localizacao: espaco
                            .descricao, // pode ajustar para endereço se tiver
                        preco:
                            'R\$ ${espaco.precoHora.toStringAsFixed(2)}/hora',
                        avaliacao: 4, // ajustar se tiver avaliação no modelo
                        tipo: espaco
                            .disponibilidadeSala, // exemplo de campo para tipo
                        onTap: () {
                          Navigator.pushNamed(context, '/alugar',
                              arguments: espaco);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class SpaceCard extends StatelessWidget {
  final String nome;
  final String localizacao;
  final String preco;
  final double avaliacao;
  final String tipo;
  final VoidCallback? onTap;

  const SpaceCard({
    Key? key,
    required this.nome,
    required this.localizacao,
    required this.preco,
    required this.avaliacao,
    required this.tipo,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                    child: Icon(Icons.image, size: 40, color: Colors.white)),
              ),
              const SizedBox(height: 8),
              Text(nome, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(localizacao, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text('$avaliacao', style: const TextStyle(fontSize: 12)),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(tipo, style: const TextStyle(fontSize: 10)),
                  ),
                ],
              ),
              const Spacer(),
              Text(preco,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green)),
            ],
          ),
        ),
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
            children: [
              _StepItem(
                icon: Icons.search,
                title: 'Busque',
                description: 'Encontre o espaço ideal para suas necessidades.',
              ),
              _StepItem(
                icon: Icons.calendar_today,
                title: 'Reserve',
                description:
                    'Escolha a data e horário e faça sua reserva em poucos cliques.',
              ),
              _StepItem(
                icon: Icons.work,
                title: 'Trabalhe',
                description: 'Aproveite um ambiente profissional e produtivo.',
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
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue.shade50,
            child: Icon(icon, size: 30, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }
}

class CTABanner extends StatelessWidget {
  const CTABanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Pronto para encontrar seu espaço ideal?',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Milhares de profissionais já encontraram o espaço perfeito para trabalhar. Junte-se a eles!',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/espacos');
            },
            child: const Text('Explorar Espaços'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
