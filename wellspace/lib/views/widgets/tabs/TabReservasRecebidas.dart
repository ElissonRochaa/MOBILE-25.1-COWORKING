import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/ReservasRecebidasViewModel.dart';
import '../ReservaRecebidaCard.dart';

class TabReservasRecebidas extends StatefulWidget {
  const TabReservasRecebidas({super.key});

  @override
  State<TabReservasRecebidas> createState() => _TabReservasRecebidasState();
}

class _TabReservasRecebidasState extends State<TabReservasRecebidas> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReservasRecebidasViewModel>(context, listen: false).carregarReservasRecebidas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReservasRecebidasViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.errorMessage != null) {
          return Center(child: Text(viewModel.errorMessage!));
        }

        if (viewModel.reservas.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Nenhuma reserva foi encontrada para suas salas.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => viewModel.carregarReservasRecebidas(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: viewModel.reservas.length,
            itemBuilder: (context, index) {
              final reserva = viewModel.reservas[index];
              return ReservaRecebidaCard(reserva: reserva);
            },
          ),
        );
      },
    );
  }
}