import 'package:flutter/material.dart';

class EspacosPage extends StatefulWidget {
  const EspacosPage({super.key});

  @override
  State<EspacosPage> createState() => _EspacosPageState();
}

class _EspacosPageState extends State<EspacosPage> {
  bool exibirMapa = false;

  List<Map<String, dynamic>> espacos = [
    {
      'tipo': 'Open Space',
      'preco': 'R\$ 120/dia',
      'nome': 'Coworking Central',
      'endereco': 'Av. Paulista, 1000, São Paulo',
      'tags': ['Wi-Fi', 'Café', 'Estacionamento', '+2 mais'],
      'favorito': false,
    },
    {
      'tipo': 'Sala Privativa',
      'preco': 'R\$ 200/dia',
      'nome': 'Office Premium',
      'endereco': 'Av. Faria Lima, 1500, São Paulo',
      'tags': ['Wi-Fi', 'Recepção', 'Salas de Reunião'],
      'favorito': true,
    },
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: const Text(
          'Todos os Espaços',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildActionButtons(),
          _buildEspacosEncontrados(),
          Expanded(
            child: exibirMapa ? _buildMapaPlaceholder() : _buildListaEspacos(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        onChanged: (value) => setState(() => searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Buscar por localização ou nome...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.filter_list, size: 18),
            label: const Text('Filtros'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.sort, size: 18),
            label: const Text('Ordenar por'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => setState(() => exibirMapa = false),
            icon: Icon(Icons.view_list,
                color: !exibirMapa ? Colors.blue : Colors.black),
          ),
          IconButton(
            onPressed: () => setState(() => exibirMapa = true),
            icon: Icon(Icons.location_on,
                color: exibirMapa ? Colors.blue : Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildEspacosEncontrados() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('6 espaços encontrados',
            style: TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildListaEspacos() {
    return ListView.builder(
      itemCount: espacos.length,
      itemBuilder: (context, index) {
        return _buildEspacoCard(espacos[index], index);
      },
    );
  }

  Widget _buildEspacoCard(Map<String, dynamic> espaco, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 130,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Center(
                    child: Icon(Icons.image, size: 40, color: Colors.white)),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(espaco['tipo'],
                      style: const TextStyle(fontSize: 12)),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    espaco['favorito'] ? Icons.favorite : Icons.favorite_border,
                    color: espaco['favorito'] ? Colors.red : Colors.grey[700],
                  ),
                  onPressed: () {
                    setState(() {
                      espacos[index]['favorito'] = !espacos[index]['favorito'];
                    });
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(espaco['nome'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(espaco['endereco'],
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: -8,
                  children: List<Widget>.from(
                    espaco['tags'].map((tag) => Chip(
                          label: Text(tag),
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        )),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      espaco['preco'],
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Ação de ver detalhes
                      },
                      child: const Text('Ver Detalhes'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapaPlaceholder() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Icon(Icons.map, size: 60, color: Colors.blue),
            SizedBox(height: 12),
            Text("Mapa do Google será integrado aqui"),
            SizedBox(height: 4),
            Text("Mostrando espaços", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
