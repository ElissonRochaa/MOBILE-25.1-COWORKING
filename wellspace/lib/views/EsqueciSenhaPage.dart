import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/PasswordRecoveryViewModel.dart';
import 'package:Wellspace/views/widgets/FormCardLayout.dart'; 


const Color primaryBlue = Color(0xFF1976D2);
const Color pageBackground = Colors.white; 
const Color cardBackground = Colors.white; 
const Color textOnPrimary = Colors.white;
const Color textPrimary = Color(0xFF212121);
const Color textSecondary = Color(0xFF757575);
const Color inputBorderColor = Color(0xFFBDBDBD);
const Color errorColor = Color(0xFFD32F2F);

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
   
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(textOnPrimary)),
            SizedBox(width: 16),
            Text('Enviando link...', style: TextStyle(color: textOnPrimary)),
          ],
        ),
        backgroundColor: primaryBlue,
      ),
    );
    await viewModel.requestPasswordResetLink(_emailController.text);
    if(mounted) ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  Widget _buildEmailInputFormContent(BuildContext context, PasswordRecoveryViewModel viewModel) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            style: const TextStyle(color: textPrimary),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "E-mail",
              labelStyle: const TextStyle(color: textSecondary),
              hintText: "Digite seu e-mail cadastrado",
              hintStyle: TextStyle(color: textSecondary.withOpacity(0.7)),
              prefixIcon: const Icon(Icons.email_outlined, color: primaryBlue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: inputBorderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: inputBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: primaryBlue, width: 2.0),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: errorColor, width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: errorColor, width: 2.0),
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
              if (viewModel.status == PasswordRecoveryStatus.error && viewModel.errorMessage.isNotEmpty) {
                viewModel.resetToInitial();
              }
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 16),
          if (viewModel.status == PasswordRecoveryStatus.error && viewModel.errorMessage.isNotEmpty)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: errorColor.withOpacity(0.3)),
              ),
              child: Text(
                viewModel.errorMessage,
                style: const TextStyle(color: errorColor, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: textOnPrimary,
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
                      valueColor: AlwaysStoppedAnimation<Color>(textOnPrimary),
                    ),
                  )
                : const Text("Enviar Link de Recuperação", style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              context.read<PasswordRecoveryViewModel>().resetToInitial();
              Navigator.of(context).pop();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_back_ios_new, size: 16.0, color: primaryBlue),
                const SizedBox(width: 4),
                Text(
                  "Voltar para o Login",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textSecondary),
            children: <TextSpan>[
              const TextSpan(text: "Enviamos um link de redefinição de senha para "),
              TextSpan(
                text: viewModel.submittedEmail,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Por favor, verifique sua caixa de entrada e também a pasta de spam.",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: textOnPrimary,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            viewModel.resetToInitial();
            Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
          },
          child: const Text("Voltar para o Login"),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: inputBorderColor), 
            foregroundColor: textPrimary, 
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            viewModel.resetToInitial();
            _emailController.clear();
          },
          child: const Text("Tentar outro e-mail", style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PasswordRecoveryViewModel>();

    String title;
    String description;
    Widget iconWidget;
    Widget contentChild;
    VoidCallback? appBarBackButtonAction;

    if (viewModel.status == PasswordRecoveryStatus.emailSent) {
      title = "Verifique seu E-mail!";
      description = "";
      iconWidget = Container(
        padding: const EdgeInsets.all(12.0),
        decoration: const BoxDecoration(
          color: primaryBlue, 
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_circle_outline,
          color: textOnPrimary, 
          size: 32.0,
        ),
      );
      contentChild = _buildEmailSentContent(context, viewModel);
      appBarBackButtonAction = () {
        viewModel.resetToInitial();
        _emailController.clear();
      };
    } else {
      title = "Esqueceu sua senha?";
      description = "Não se preocupe! Digite seu e-mail abaixo e enviaremos um link para você criar uma nova senha.";
      iconWidget = Container(
        padding: const EdgeInsets.all(12.0),
        decoration: const BoxDecoration(
          color: primaryBlue, 
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.mail_outline,
          color: textOnPrimary, 
          size: 32.0,
        ),
      );
      contentChild = _buildEmailInputFormContent(context, viewModel);
      appBarBackButtonAction = () {
        viewModel.resetToInitial();
        Navigator.of(context).pop();
      };
    }

    return FormCardLayout(
      iconWidget: iconWidget,
      title: title,
      titleStyle: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      description: description,
      descriptionStyle: const TextStyle( 
        fontSize: 16,
        color: textSecondary,
      ),
      child: contentChild,
      appBar: AppBar(
        backgroundColor: pageBackground, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryBlue), 
          onPressed: appBarBackButtonAction,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}