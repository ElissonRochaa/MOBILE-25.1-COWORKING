import 'package:flutter/material.dart';
import '../models/Sala.dart';
import '../services/SalaService.dart';

class SalaListViewModel extends ChangeNotifier {
  List<Sala> salas = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> carregarSalas() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      salas = await SalaService.listarSalas();
    } catch (e) {
      errorMessage = 'Erro ao carregar salas: $e';
      salas = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
