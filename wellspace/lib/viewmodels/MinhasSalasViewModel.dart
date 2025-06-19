import 'package:flutter/material.dart';
import '../models/Sala.dart';
import '../services/SalaService.dart';
import '../services/UsuarioService.dart';

class MinhasSalasViewModel extends ChangeNotifier {
  List<Sala> _salas = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Sala> get salas => _salas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> carregarMinhasSalas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final usuarioId = await UsuarioService.obterUsuarioId();
      if (usuarioId == null) {
        throw Exception("ID do usuário não encontrado.");
      }
      _salas = await SalaService.listarSalasPorUsuarioId(usuarioId);
    } catch (e) {
      _errorMessage = 'Erro ao carregar suas salas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}