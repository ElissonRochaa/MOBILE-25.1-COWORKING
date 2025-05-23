import 'package:flutter/foundation.dart';
import '../models/Usuario.dart';
import '../services/UsuarioService.dart';

class UsuarioDetailViewModel extends ChangeNotifier {
  Usuario? _usuario;
  bool _isLoading = false;
  String? _errorMessage;

  Usuario? get usuario => _usuario;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> carregarUsuarioPorId() async {
    _isLoading = true;
    _errorMessage = null;
    _usuario = null;
    notifyListeners();

    try {
      final fetchedUsuario = await UsuarioService.buscarUsuarioPorId();
      _usuario = fetchedUsuario;
    } catch (e) {
      _errorMessage = 'Erro ao carregar usuário: $e';
      _usuario = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void limparUsuario() {
    _usuario = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
