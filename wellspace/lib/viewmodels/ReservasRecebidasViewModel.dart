import 'package:flutter/material.dart';
import '../models/Reserva.dart';
import '../services/ReservaService.dart';
import '../services/UsuarioService.dart';

class ReservasRecebidasViewModel extends ChangeNotifier {
  List<Reserva> _reservas = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Reserva> get reservas => _reservas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> carregarReservasRecebidas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final usuarioId = await UsuarioService.obterUsuarioId();
      if (usuarioId == null) {
        throw Exception("ID do usuário não encontrado.");
      }
      _reservas = await ReservaService.listarReservasParaLocador(usuarioId);
    } catch (e) {
      _errorMessage = 'Erro ao carregar as reservas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

