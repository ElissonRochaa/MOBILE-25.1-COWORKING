import 'package:flutter/material.dart';
import 'widgets/sideMenu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Encontre o espaço de trabalho perfeito para você'),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: SideMenu(),  // Adiciona o SideMenu como o drawer da home page
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por localização ou tipo de espaço...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Cadastre sua sala',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Espaços em Destaque',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildSpaceCard(
              'Coworking Central',
              'Av. Paulista, 1000, São Paulo',
              'R\$ 120/dia',
              4.8,
            ),
            const SizedBox(height: 16),
            _buildSpaceCard(
              'Coworking Paulista',
              'Av. Paulista, 1500, São Paulo',
              'R\$ 150/dia',
              4.5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpaceCard(
    String nome,
    String localizacao,
    String preco,
    double avaliacao,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              color: Colors.grey[300],
              child: Icon(Icons.business, size: 50, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(localizacao),
                const SizedBox(height: 8),
                Text(
                  preco,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow[700]),
                    const SizedBox(width: 4),
                    Text('$avaliacao'),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Open Space'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
