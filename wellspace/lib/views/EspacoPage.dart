import 'package:Wellspace/views/widgets/SalaCard.dart';
import 'package:Wellspace/views/widgets/sideMenu.dart';
import 'package:flutter/material.dart';
import '../models/Sala.dart';
import '../viewmodels/SalaListViewModel.dart';

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
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    final List<Sala> salasFiltradas = salaListViewModel.salas.where((sala) {
      return sala.nomeSala.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      drawer: SideMenu(),
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Text(
          'Todos os Espaços',
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(context, theme, isDarkMode),
          _buildActionButtons(context, theme, isDarkMode),
          _buildEspacosEncontrados(context, theme, salasFiltradas.length),
          Expanded(
            child: exibirMapa
                ? _buildMapaPlaceholder(context, theme, isDarkMode)
                : _buildListaEspacos(context, theme, salasFiltradas),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(
      BuildContext context, ThemeData theme, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        onChanged: (value) => setState(() => searchQuery = value),
        style: TextStyle(color: theme.colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: 'Buscar por nome',
          hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          prefixIcon:
              Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
          filled: true,
          fillColor: isDarkMode
              ? theme.colorScheme.surfaceVariant.withOpacity(0.5)
              : Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: theme.colorScheme.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, ThemeData theme, bool isDarkMode) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.surfaceVariant,
      foregroundColor: theme.colorScheme.onSurfaceVariant,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.filter_list, size: 18),
            label: const Text('Filtros'),
            style: buttonStyle,
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.sort, size: 18),
            label: const Text('Ordenar por'),
            style: buttonStyle,
          ),
          const Spacer(),
          IconButton(
            onPressed: () => setState(() => exibirMapa = false),
            icon: Icon(Icons.view_list,
                color: !exibirMapa
                    ? theme.colorScheme.primary
                    : theme.iconTheme.color),
            tooltip: 'Visualizar em lista',
          ),
          IconButton(
            onPressed: () => setState(() => exibirMapa = true),
            icon: Icon(Icons.location_on,
                color: exibirMapa
                    ? theme.colorScheme.primary
                    : theme.iconTheme.color),
            tooltip: 'Visualizar no mapa',
          ),
        ],
      ),
    );
  }

  Widget _buildEspacosEncontrados(
      BuildContext context, ThemeData theme, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('$count espaços encontrados',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onBackground)),
      ),
    );
  }

  Widget _buildListaEspacos(
      BuildContext context, ThemeData theme, List<Sala> salas) {
    if (salaListViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (salaListViewModel.errorMessage != null) {
      return Center(
          child: Text(salaListViewModel.errorMessage!,
              style: TextStyle(color: theme.colorScheme.error)));
    }
    if (salas.isEmpty) {
      return Center(
          child: Text('Nenhum espaço encontrado',
              style: TextStyle(color: theme.colorScheme.onBackground)));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      itemCount: salas.length,
      itemBuilder: (context, index) {
        return _buildSalaCard(salas[index]);
      },
    );
  }

  Widget _buildSalaCard(Sala sala) {
    return SalaCard(sala: sala);
  }

  Widget _buildMapaPlaceholder(
      BuildContext context, ThemeData theme, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Icon(Icons.map, size: 60, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text("Mapa do Google será integrado aqui",
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text("Mostrando espaços",
                style: TextStyle(
                    color:
                        theme.colorScheme.onSurfaceVariant.withOpacity(0.7))),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
