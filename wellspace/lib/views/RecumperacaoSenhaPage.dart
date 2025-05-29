import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wellspace/viewmodels/PasswordRecoveryViewModel.dart';
import 'package:Wellspace/views/widgets/PasswordInputField.dart';
import 'package:Wellspace/views/widgets/PasswordRequirementsView.dart';

const Color wellSpaceTeal50 = Color(0xFFF0FDFA);
const Color wellSpaceBlue50 = Color(0xFFEFF6FF);
const Color wellSpaceTeal100 = Color(0xFFCCFBF1);
const Color wellSpaceTeal600 = Color(0xFF0D9488);
const Color wellSpaceGreen100 = Color(0xFFDCFCE7);
const Color wellSpaceGreen600 = Color(0xFF16A34A);
const Color wellSpaceErrorRed = Color(0xFFEF4444);
const Color wellSpaceMutedForeground = Color(0xFF6B7280);
const Color wellSpaceForeground = Color(0xFF1F2937);
const Color wellSpaceCardBackground = Colors.white;

class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _localError = "";
  bool _doPasswordsMatch = false;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<PasswordRecoveryViewModel>(context, listen: false);
    _passwordController.addListener(() {
      viewModel.updatePasswordRequirements(_passwordController.text);
      _updatePasswordMatch();
      if (_localError.isNotEmpty) {
        setState(() {
          _localError = "";
        });
      }
    });
    _confirmPasswordController.addListener(() {
      _updatePasswordMatch();
       if (_localError.isNotEmpty) {
        setState(() {
          _localError = "";
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.resetToInitial();
        viewModel.updatePasswordRequirements('');
    });
  }

  void _updatePasswordMatch() {
    setState(() {
      _doPasswordsMatch = _passwordController.text == _confirmPasswordController.text &&
          _confirmPasswordController.text.isNotEmpty;
    });
  }

  Future<void> _handleSubmit(PasswordRecoveryViewModel viewModel) async {
    setState(() => _localError = "");

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!viewModel.isPasswordCompliant) {
      setState(() => _localError = "A senha não atende aos requisitos mínimos.");
      return;
    }

    if (!_doPasswordsMatch) {
      setState(() => _localError = "As senhas não coincidem.");
      return;
    }
    await viewModel.submitNewPassword(widget.token, _passwordController.text);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildSuccessScreen(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [wellSpaceTeal50, wellSpaceBlue50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              color: wellSpaceCardBackground,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: const BoxDecoration(
                        color: wellSpaceGreen100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        color: wellSpaceGreen600,
                        size: 32.0,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Sucesso!",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: wellSpaceForeground,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Sua senha foi alterada com sucesso. Você já pode fazer login com sua nova senha.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: wellSpaceMutedForeground),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: wellSpaceTeal600,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        Provider.of<PasswordRecoveryViewModel>(context, listen: false).resetToInitial();
                        Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
                      },
                      child: const Text("Ir para o Login"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetPasswordFormScreen(BuildContext context, PasswordRecoveryViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: wellSpaceTeal600),
          onPressed: () {
            viewModel.resetToInitial();
            Navigator.of(context).pop();
            },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [wellSpaceTeal50, wellSpaceBlue50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              color: wellSpaceCardBackground,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: const BoxDecoration(
                          color: wellSpaceTeal100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          color: wellSpaceTeal600,
                          size: 32.0,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Crie sua Nova Senha",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: wellSpaceForeground,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Escolha uma senha forte e que você não tenha usado antes.",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: wellSpaceMutedForeground),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      PasswordInputField(
                        controller: _passwordController,
                        labelText: "Nova Senha",
                        hintText: "Digite sua nova senha",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Por favor, digite a nova senha";
                          }
                          if (!viewModel.isPasswordCompliant && value.isNotEmpty) {
                            return "A senha não atende aos requisitos";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      if (_passwordController.text.isNotEmpty)
                        PasswordRequirementsView(
                          password: _passwordController.text,
                          requirements: viewModel.passwordRequirements,
                        ),
                      const SizedBox(height: 16),
                      PasswordInputField(
                        controller: _confirmPasswordController,
                        labelText: "Confirmar Nova Senha",
                        hintText: "Confirme sua nova senha",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Por favor, confirme a nova senha";
                          }
                          if (_passwordController.text != value) {
                            return "As senhas não coincidem";
                          }
                          return null;
                        },
                        showErrorBorder: _confirmPasswordController.text.isNotEmpty && !_doPasswordsMatch,
                      ),
                      if (_confirmPasswordController.text.isNotEmpty && !_doPasswordsMatch)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text("As senhas não coincidem", style: TextStyle(color: wellSpaceErrorRed, fontSize: 12)),
                        ),
                      if (_confirmPasswordController.text.isNotEmpty && _doPasswordsMatch)
                         Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: [
                              Icon(Icons.check, color: wellSpaceGreen600, size: 14),
                              SizedBox(width: 4),
                              Text("As senhas coincidem", style: TextStyle(color: wellSpaceGreen600, fontSize: 12)),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),
                      if (_localError.isNotEmpty)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16.0),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: wellSpaceErrorRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: wellSpaceErrorRed.withOpacity(0.3)),
                          ),
                          child: Text(
                            _localError,
                            style: const TextStyle(color: wellSpaceErrorRed, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (viewModel.status == PasswordRecoveryStatus.error && viewModel.errorMessage.isNotEmpty)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16.0),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            color: wellSpaceErrorRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: wellSpaceErrorRed.withOpacity(0.3)),
                          ),
                          child: Text(
                            viewModel.errorMessage,
                            style: const TextStyle(color: wellSpaceErrorRed, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: wellSpaceTeal600,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: viewModel.status == PasswordRecoveryStatus.loadingReset || !viewModel.isPasswordCompliant ||!_doPasswordsMatch
                            ? null
                            : () => _handleSubmit(viewModel),
                        child: viewModel.status == PasswordRecoveryStatus.loadingReset
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text("Redefinir Senha", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PasswordRecoveryViewModel>();
    return viewModel.status == PasswordRecoveryStatus.resetSuccess
        ? _buildSuccessScreen(context)
        : _buildResetPasswordFormScreen(context, viewModel);
  }
}