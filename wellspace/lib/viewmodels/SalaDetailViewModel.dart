import 'package:flutter/foundation.dart';
import '../models/Sala.dart';
import '../services/SalaService.dart';

class SalaDetailViewModel extends ChangeNotifier {
  Sala? _sala;
  bool _isLoading = false;
  String? _errorMessage;

  Sala? get sala => _sala;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> carregarSalaPorId(String id) async {
    _isLoading = true;
    _errorMessage = null;
    _sala = null;
    notifyListeners();

    try {
      final fetchedSala = await SalaService.buscarSalaPorId(id);
      _sala = fetchedSala;

      if (_sala == null && _isLoading) {}
    } catch (e) {
      _errorMessage = 'Erro ao carregar detalhes da sala: $e';
      _sala = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void limparDetalhesSala() {
    _sala = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
