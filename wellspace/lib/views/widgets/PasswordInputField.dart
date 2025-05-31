import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF1976D2);
const Color textPrimary = Color(0xFF212121);
const Color textSecondary = Color(0xFF757575);
const Color inputBorderColor = Color(0xFFBDBDBD);
const Color errorColor = Color(0xFFD32F2F);

class PasswordInputField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool initialObscureText;
  final bool showErrorBorder; 

  const PasswordInputField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.onChanged,
    this.validator,
    this.initialObscureText = true,
    this.showErrorBorder = false,
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.initialObscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    bool displayErrorFromValidator = false;
    if (widget.validator != null) {
      final validationResult = widget.validator!(widget.controller.text);
      if (validationResult != null && validationResult.isNotEmpty) {
        displayErrorFromValidator = true;
      }
    }
    final bool shouldCurrentlyDisplayError = widget.showErrorBorder || displayErrorFromValidator;

    return TextFormField(
      controller: widget.controller,
      style: const TextStyle(color: textPrimary),
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: textSecondary),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: textSecondary.withOpacity(0.7)),
        prefixIcon: const Icon(Icons.lock_outline_rounded, color: primaryBlue),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: textSecondary,
          ),
          onPressed: _toggleVisibility,
        ),
       
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: shouldCurrentlyDisplayError ? errorColor : inputBorderColor),
        ),
     
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: shouldCurrentlyDisplayError ? errorColor : inputBorderColor),
        ),
       
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
       
          borderSide: BorderSide(color: shouldCurrentlyDisplayError ? errorColor : primaryBlue, width: 2.0),
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
      onChanged: widget.onChanged,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}