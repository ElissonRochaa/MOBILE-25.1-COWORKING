import 'package:flutter/material.dart';
import '../services/UsuarioService.dart';

enum PasswordRecoveryStatus {
  initial,
  loadingRequest,
  emailSent,
  loadingReset,
  resetSuccess,
  error
}

class PasswordRecoveryViewModel extends ChangeNotifier {
  PasswordRecoveryStatus _status = PasswordRecoveryStatus.initial;
  PasswordRecoveryStatus get status => _status;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _submittedEmail = '';
  String get submittedEmail => _submittedEmail;

  final List<PasswordRequirement> _passwordRequirements = [
    PasswordRequirement(label: "Mínimo 8 caracteres", test: (pwd) => pwd.length >= 8),
    PasswordRequirement(label: "Pelo menos uma letra maiúscula", test: (pwd) => RegExp(r'[A-Z]').hasMatch(pwd)),
    PasswordRequirement(label: "Pelo menos uma letra minúscula", test: (pwd) => RegExp(r'[a-z]').hasMatch(pwd)),
    PasswordRequirement(label: "Pelo menos um número", test: (pwd) => RegExp(r'\d').hasMatch(pwd)),
    PasswordRequirement(label: "Pelo menos um caractere especial", test: (pwd) => RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(pwd)),
  ];
  List<PasswordRequirement> get passwordRequirements => _passwordRequirements;

  bool _isPasswordCompliant = false;
  bool get isPasswordCompliant => _isPasswordCompliant;

  void updatePasswordRequirements(String password) {
    bool compliant = true;
    for (var req in _passwordRequirements) {
      req.isValid = req.test(password);
      if (!req.isValid) compliant = false;
    }
    _isPasswordCompliant = compliant;
    notifyListeners();
  }

  void _setStatus(PasswordRecoveryStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = PasswordRecoveryStatus.error;
    notifyListeners();
  }

  Future<void> requestPasswordResetLink(String email) async {
    _setStatus(PasswordRecoveryStatus.loadingRequest);
    _errorMessage = '';
    _submittedEmail = email;

    try {
      await UsuarioService.requestPasswordReset(email);
      _setStatus(PasswordRecoveryStatus.emailSent);
    } catch (e) {
      String exceptionString = e.toString();
      String displayMessage = "Não foi possível enviar o link. Tente novamente.";
      if (exceptionString.contains("Falha ao solicitar redefinição de senha:")) {
        var parts = exceptionString.split("Falha ao solicitar redefinição de senha:");
        if (parts.length > 1) {
          displayMessage = parts[1].trim();
        }
      } else if (exceptionString.contains("Tempo de requisição esgotado")) {
        displayMessage = "Tempo de requisição esgotado. Verifique sua conexão e tente novamente.";
      } else if (exceptionString.contains("Erro de conexão")) {
        displayMessage = "Erro de conexão. Verifique sua internet e tente novamente.";
      }
      _setError(displayMessage);
    }
  }

  Future<bool> submitNewPassword(String token, String newPassword) async {
    _setStatus(PasswordRecoveryStatus.loadingReset);
    _errorMessage = '';

    try {
      await UsuarioService.submitNewPassword(token, newPassword);
      _setStatus(PasswordRecoveryStatus.resetSuccess);
      return true;
    } catch (e) {
      String exceptionString = e.toString();
      String displayMessage = "Não foi possível redefinir a senha. Verifique o token ou tente novamente.";
      if (exceptionString.contains("Falha ao redefinir senha:")) {
         var parts = exceptionString.split("Falha ao redefinir senha:");
         if (parts.length > 1) {
            displayMessage = parts[1].trim();
         }
      } else if (exceptionString.contains("Tempo de requisição esgotado")) {
        displayMessage = "Tempo de requisição esgotado. Verifique sua conexão e tente novamente.";
      } else if (exceptionString.contains("Erro de conexão")) {
        displayMessage = "Erro de conexão. Verifique sua internet e tente novamente.";
      }
      _setError(displayMessage);
      return false;
    }
  }

  void resetToInitial() {
    _submittedEmail = '';
    _errorMessage = '';
    _setStatus(PasswordRecoveryStatus.initial);
  }
}

class PasswordRequirement {
  final String label;
  final bool Function(String) test;
  bool isValid;

  PasswordRequirement({required this.label, required this.test, this.isValid = false});
}