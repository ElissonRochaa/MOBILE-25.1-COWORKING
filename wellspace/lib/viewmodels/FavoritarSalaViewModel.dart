import 'package:Wellspace/services/UsuarioService.dart';
import 'package:flutter/material.dart';
import '../models/Favorito.dart';
import '../services/SalaService.dart';

class FavoritoViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _favoritoCriado = false;
  bool _favoritoDeletado = false;
  List<Favorito> _favoritos = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get favoritoCriado => _favoritoCriado;
  bool get favoritoDeletado => _favoritoDeletado;
  List<Favorito> get favoritos => _favoritos;

  Future<void> favoritarSala(String usuarioId, String salaId) async {
    _isLoading = true;
    _errorMessage = null;
    _favoritoCriado = false;
    notifyListeners();

    try {
      final sucesso = await SalaService.favoritarSala(usuarioId, salaId);
      if (sucesso) {
        _favoritoCriado = true;
      } else {
        _errorMessage = "Erro ao favoritar a sala.";
      }
    } catch (e) {
      _errorMessage = "Exceção ao favoritar a sala: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> listarFavoritosUsuarioLogado() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final usuarioId = await UsuarioService.obterUsuarioId();

      if (usuarioId == null || usuarioId.isEmpty) {
        _errorMessage = "Usuário não autenticado.";
        _favoritos = [];
      } else {
        _favoritos = await SalaService.listarFavoritosPorUsuario(usuarioId);
      }
    } catch (e) {
      _errorMessage = "Erro ao listar favoritos do usuário logado: $e";
      _favoritos = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletarFavorito(String favoritoId) async {
    _isLoading = true;
    _errorMessage = null;
    _favoritoDeletado = false;
    notifyListeners();

    try {
      final sucesso = await SalaService.deletarFavorito(favoritoId);
      if (sucesso) {
        _favoritoDeletado = true;
        _favoritos.removeWhere((f) => f.favoritoId == favoritoId);
      } else {
        _errorMessage = "Erro ao deletar o favorito.";
      }
    } catch (e) {
      _errorMessage = "Exceção ao deletar o favorito: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
