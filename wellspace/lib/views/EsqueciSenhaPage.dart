import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/PasswordRecoveryViewModel.dart';
import 'package:Wellspace/views/widgets/FormCardLayout.dart';

const Color wellSpaceTeal100 = Color(0xFFCCFBF1);
const Color wellSpaceTeal600 = Color(0xFF0D9488);
const Color wellSpaceGreen100 = Color(0xFFDCFCE7);
const Color wellSpaceGreen600 = Color(0xFF16A34A);
const Color wellSpaceErrorRed = Color(0xFFEF4444);
const Color wellSpaceInputBorder = Color(0xFFD1D5DB);
const Color wellSpaceMutedForeground = Color(0xFF6B7280);

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _validateEmail(String email) {
    const emailRegex = r"^[^\s@]+@[^\s@]+\.[^\s@]+$";
    return RegExp(emailRegex).hasMatch(email);
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final viewModel = context.read<PasswordRecoveryViewModel>();
    await viewModel.requestPasswordResetLink(_emailController.text);
  }

  Widget _buildEmailInputFormContent(BuildContext context, PasswordRecoveryViewModel viewModel) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "E-mail",
              hintText: "Digite seu e-mail cadastrado",
              prefixIcon: const Icon(Icons.email_outlined, color: wellSpaceTeal600),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: wellSpaceInputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: wellSpaceTeal600, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: wellSpaceErrorRed, width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: wellSpaceErrorRed, width: 2.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Por favor, digite seu e-mail";
              }
              if (!_validateEmail(value)) {
                return "Por favor, digite um e-mail válido";
              }
              return null;
            },
            onChanged: (value) {
              if (viewModel.status == PasswordRecoveryStatus.error) {
                viewModel.resetToInitial();
              }
            },
          ),
          const SizedBox(height: 16),
          if (viewModel.status == PasswordRecoveryStatus.error && viewModel.errorMessage.isNotEmpty)
            Container(
              width: double.infinity,
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
          if (viewModel.status == PasswordRecoveryStatus.error && viewModel.errorMessage.isNotEmpty)
            const SizedBox(height: 16),
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
            onPressed: viewModel.status == PasswordRecoveryStatus.loadingRequest
                ? null
                : () => _handleSubmit(context),
            child: viewModel.status == PasswordRecoveryStatus.loadingRequest
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text("Enviar Link de Recuperação", style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_back_ios_new, size: 16.0, color: wellSpaceMutedForeground),
                const SizedBox(width: 4),
                Text(
                  "Voltar para o Login",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: wellSpaceMutedForeground),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailSentContent(BuildContext context, PasswordRecoveryViewModel viewModel) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: wellSpaceMutedForeground),
            children: <TextSpan>[
              const TextSpan(text: "Enviamos um link de redefinição de senha para "),
              TextSpan(
                text: viewModel.submittedEmail,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Por favor, verifique sua caixa de entrada e também a pasta de spam.",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: wellSpaceMutedForeground),
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
            viewModel.resetToInitial();
            Navigator.of(context).pushReplacementNamed('/login');
          },
          child: const Text("Voltar para o Login"),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: wellSpaceTeal600.withOpacity(0.5)),
            foregroundColor: wellSpaceTeal600,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            viewModel.resetToInitial();
            _emailController.clear();
          },
          child: const Text("Tentar outro e-mail"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PasswordRecoveryViewModel>();

    if (viewModel.status == PasswordRecoveryStatus.emailSent) {
      return FormCardLayout(
        iconWidget: Container(
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
        title: "Verifique seu E-mail!",
        description: "",
        child: _buildEmailSentContent(context, viewModel),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: wellSpaceTeal600),
            onPressed: () {
              viewModel.resetToInitial();
              _emailController.clear();
            },
          ),
        ),
      );
    } else {
      return FormCardLayout(
        iconWidget: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: const BoxDecoration(
            color: wellSpaceTeal100,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mail_outline,
            color: wellSpaceTeal600,
            size: 32.0,
          ),
        ),
        title: "Esqueceu sua senha?",
        description: "Não se preocupe! Digite seu e-mail abaixo e enviaremos um link para você criar uma nova senha.",
        child: _buildEmailInputFormContent(context, viewModel),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: wellSpaceTeal600),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}