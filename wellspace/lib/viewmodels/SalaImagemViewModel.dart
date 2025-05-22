import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/SalaImagesService.dart';

class SalaImagemViewModel extends ChangeNotifier {
  bool _isUploading = false;
  String? _errorMsg;
  List<String> imagensCadastradas = [];

  bool get isUploading => _isUploading;
  String? get errorMsg => _errorMsg;

  Future<void> listarImagensPorSala(String salaId) async {
    imagensCadastradas = await SalaImagemService.listarImagensPorSala(salaId);
    notifyListeners();
  }

  Future<bool> uploadImagemBytes(String salaId, Uint8List bytes, String fileName) async {
    _isUploading = true;
    _errorMsg = null;
    notifyListeners();

    final sucesso = await SalaImagemService.cadastrarSalaImagemFromBytes(
      salaId: salaId,
      imagemBytes: bytes,
      fileName: fileName,
    );

    _isUploading = false;

    if (sucesso) {
      await listarImagensPorSala(salaId);
      notifyListeners();
      return true;
    } else {
      _errorMsg = "Falha ao enviar imagem.";
      notifyListeners();
      return false;
    }
  }

  void resetError() {
    _errorMsg = null;
    notifyListeners();
  }
}
