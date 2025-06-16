import 'package:Wellspace/models/Reserva.dart';
import 'package:Wellspace/services/ReservaService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ReservaViewModel extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  List<Reserva> _minhasReservas = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Reserva> get minhasReservas => _minhasReservas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> carregarMinhasReservas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final usuarioId = await _storage.read(key: 'usuario_id');
      if (usuarioId == null || usuarioId.isEmpty) {
        throw Exception("ID do usuário não encontrado. Faça login novamente.");
      }

      _minhasReservas =
          await ReservaService.buscarReservasPorLocatario(usuarioId);
    } catch (e) {
      _errorMessage = e.toString();
      print('[ReservaViewModel] Erro ao carregar reservas: $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> criarNovaReserva({
    required BuildContext context,
    required ReservaRequest request,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final novaReserva = await ReservaService.criarReserva(request);
      if (novaReserva != null) {
        await carregarMinhasReservas();
        _showSnackBar(context, 'Reserva criada com sucesso!');
        return true;
      } else {
        _showSnackBar(context, 'Não foi possível criar a reserva.',
            isError: true);
        return false;
      }
    } catch (e) {
      _showSnackBar(context, 'Erro de comunicação: ${e.toString()}',
          isError: true);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}
