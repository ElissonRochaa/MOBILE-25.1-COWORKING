import 'package:flutter/material.dart';
import 'package:Wellspace/views/widgets/EspacoCard.dart';

class FavoritosTab extends StatelessWidget {
  const FavoritosTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
          const SizedBox(height: 24),
          SizedBox(
            height: 260,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                SizedBox(width: 8),
                EspacoCard(
                  nome: 'Coworking Central',
                  localizacao: 'Av. Paulista, 1000, São Paulo',
                  preco: 'R\$ 120/dia',
                  avaliacao: 4.8,
                  tipo: 'Open Space',
                ),
                EspacoCard(
                  nome: 'Office Premium',
                  localizacao: 'Rua Augusta, 500, São Paulo',
                  preco: 'R\$ 200/dia',
                  avaliacao: 4.8,
                  tipo: 'Sala Privativa',
                ),
                SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
