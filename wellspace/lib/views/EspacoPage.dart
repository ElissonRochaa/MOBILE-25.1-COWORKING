import 'package:Wellspace/views/widgets/sideMenu.dart';
import 'package:flutter/material.dart';
import '../models/Sala.dart';
import '../viewmodels/SalaListViewModel.dart'; // importe seu viewmodel

class EspacosPage extends StatefulWidget {
  const EspacosPage({super.key});

  @override
  State<EspacosPage> createState() => _EspacosPageState();
}

class _EspacosPageState extends State<EspacosPage> {
  bool exibirMapa = false;
  final SalaListViewModel salaListViewModel = SalaListViewModel();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    salaListViewModel.carregarSalas().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Sala> salasFiltradas = salaListViewModel.salas.where((sala) {
      return sala.nomeSala.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      drawer: SideMenu(),
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
          _buildEspacosEncontrados(salasFiltradas.length),
          Expanded(
            child: exibirMapa
                ? _buildMapaPlaceholder()
                : _buildListaEspacos(salasFiltradas),
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
          hintText: 'Buscar por nome',
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

  Widget _buildEspacosEncontrados(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('$count espaços encontrados',
            style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildListaEspacos(List<Sala> salas) {
    if (salaListViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (salaListViewModel.errorMessage != null) {
      return Center(child: Text(salaListViewModel.errorMessage!));
    }
    if (salas.isEmpty) {
      return const Center(child: Text('Nenhum espaço encontrado'));
    }
    return ListView.builder(
      itemCount: salas.length,
      itemBuilder: (context, index) {
        return _buildSalaCard(salas[index]);
      },
    );
  }

  Widget _buildSalaCard(Sala sala) {
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
                    child: Icon(Icons.meeting_room,
                        size: 40, color: Colors.white)),
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
                  child: Text(
                    sala.disponibilidadeSala,
                    style: const TextStyle(fontSize: 12),
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
                Text(sala.nomeSala,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(sala.descricao,
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  'Tamanho: ${sala.tamanho}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Disponível: ${sala.disponibilidadeDiaSemana} - ${sala.disponibilidadeInicio} até ${sala.disponibilidadeFim}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'R\$ ${sala.precoHora.toStringAsFixed(2)}/hora',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/alugar');
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
