// viewmodels/suporte_viewmodel.dart
import 'package:flutter/material.dart';
import '../services/ChatService.dart';

class SuporteViewModel extends ChangeNotifier {
  final ChatService _chatService = ChatService();

  final List<Map<String, String>> _chatMessages = [];
  bool _isLoading = false;

  List<Map<String, String>> get chatMessages => _chatMessages;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _chatMessages.add({"from": "user", "text": text});
    _isLoading = true;
    notifyListeners();

    try {
      final reply = await _chatService.sendMessage(text);
      _chatMessages.add({"from": "bot", "text": reply});
    } catch (e) {
      _chatMessages.add(
          {"from": "bot", "text": "Falha ao obter resposta. Tente novamente."});
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
