import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/MinhasSalasViewModel.dart';
import '../SalaCard.dart';

class TabMinhasSalas extends StatefulWidget {
  const TabMinhasSalas({super.key});

  @override
  State<TabMinhasSalas> createState() => _TabMinhasSalasState();
}

class _TabMinhasSalasState extends State<TabMinhasSalas> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MinhasSalasViewModel>(context, listen: false).carregarMinhasSalas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MinhasSalasViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.errorMessage != null) {
          return Center(child: Text(viewModel.errorMessage!));
        }

        if (viewModel.salas.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Você ainda não cadastrou nenhuma sala.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => viewModel.carregarMinhasSalas(),
          child: ListView.builder(
            itemCount: viewModel.salas.length,
            itemBuilder: (context, index) {
              final sala = viewModel.salas[index];
              return SalaCard(sala: sala);
            },
          ),
        );
      },
    );
  }
}