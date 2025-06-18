import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/MinhasSalasViewModel.dart';
import '../viewmodels/ReservasRecebidasViewModel.dart';
import 'widgets/sideMenu.dart';
import 'widgets/tabs/TabMinhasSalas.dart';
import 'widgets/tabs/TabReservasRecebidas.dart';

class MeusEspacosPage extends StatefulWidget {
  const MeusEspacosPage({super.key});

  @override
  State<MeusEspacosPage> createState() => _MeusEspacosPageState();
}

class _MeusEspacosPageState extends State<MeusEspacosPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabContent = [
      ChangeNotifierProvider(
        create: (_) => MinhasSalasViewModel(),
        child: const TabMinhasSalas(),
      ),
      ChangeNotifierProvider(
        create: (_) => ReservasRecebidasViewModel(),
        child: const TabReservasRecebidas(),
      ),
    ];

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text('Meus Espaços'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _CustomTabSelector(
              selectedTab: _selectedTab,
              onTabChanged: (index) => setState(() => _selectedTab = index),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: tabContent,
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedTab == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cadastroSala');
              },
              child: const Icon(Icons.add),
              tooltip: 'Cadastrar Nova Sala',
            )
          : null,
    );
  }
}

class _CustomTabSelector extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;

  const _CustomTabSelector({
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final tabs = ['Minhas Salas', 'Reservas Recebidas'];

    return Row(
      children: List.generate(tabs.length, (index) {
        final bool selected = selectedTab == index;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTabChanged(index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selected ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                tabs[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: selected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}