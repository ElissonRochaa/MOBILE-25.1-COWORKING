import 'package:Wellspace/viewmodels/FavoritarSalaViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wellspace/models/Sala.dart';
import 'package:Wellspace/services/SalaService.dart';
import 'package:Wellspace/views/widgets/SalaCard.dart';

class FavoritosTab extends StatefulWidget {
  const FavoritosTab({super.key});

  @override
  State<FavoritosTab> createState() => _FavoritosTabState();
}

class _FavoritosTabState extends State<FavoritosTab> {
  bool isLoading = true;
  List<Sala> salasFavoritas = [];

  @override
  void initState() {
    super.initState();
    _carregarSalasFavoritas();
  }

  Future<void> _carregarSalasFavoritas() async {
    final favoritoVM = Provider.of<FavoritoViewModel>(context, listen: false);

    try {
      await favoritoVM.listarFavoritosUsuarioLogado();

      List<Sala> salas = [];

      for (var favorito in favoritoVM.favoritos) {
        final sala = await SalaService.buscarSalaPorId(favorito.salaId);
        if (sala != null) {
          salas.add(sala);
        }
      }

      setState(() {
        salasFavoritas = salas;
        isLoading = false;
      });
    } catch (e) {
      print('[FavoritosTab] Erro ao carregar favoritos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Espaços Favoritos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Espaços que você salvou para acessar facilmente',
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            const SizedBox(height: 16),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : salasFavoritas.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum espaço favoritado ainda.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : SizedBox(
                        height: 360,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: salasFavoritas.length,
                          itemBuilder: (context, index) {
                            final sala = salasFavoritas[index];
                            return Container(
                              width: 300,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: SalaCard(sala: sala),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
