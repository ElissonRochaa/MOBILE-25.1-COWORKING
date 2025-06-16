import 'package:Wellspace/viewmodels/ReservaViewModel.dart';
import 'package:Wellspace/views/widgets/sideMenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wellspace/views/widgets/ReservaInfoCard.dart';

class MinhasReservasScreen extends StatefulWidget {
  const MinhasReservasScreen({super.key});

  @override
  State<MinhasReservasScreen> createState() => _MinhasReservasScreenState();
}

class _MinhasReservasScreenState extends State<MinhasReservasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReservaViewModel>(context, listen: false)
          .carregarMinhasReservas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReservaViewModel>();

    final theme = Theme.of(context);

    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: const Text('Minhas Reservas'),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _buildBody(viewModel, theme),
    );
  }

  Widget _buildBody(ReservaViewModel viewModel, ThemeData theme) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Ocorreu um erro: ${viewModel.errorMessage}',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
      );
    }

    if (viewModel.minhasReservas.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Você ainda não possui nenhuma reserva.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.carregarMinhasReservas(),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        itemCount: viewModel.minhasReservas.length,
        itemBuilder: (context, index) {
          final reserva = viewModel.minhasReservas[index];
          return ReservaInfoCard(reserva: reserva);
        },
      ),
    );
  }
}
