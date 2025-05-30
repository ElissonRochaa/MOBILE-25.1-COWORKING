import 'package:flutter/material.dart';

const Color wellSpaceTeal600 = Color(0xFF0D9488);
const Color wellSpaceMutedForeground = Color(0xFF6B7280);
const Color wellSpaceInputBorder = Color(0xFFD1D5DB);
const Color wellSpaceErrorRed = Color(0xFFEF4444);

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
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.lock_outline_rounded, color: wellSpaceTeal600),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: wellSpaceMutedForeground,
          ),
          onPressed: _toggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: widget.showErrorBorder ? wellSpaceErrorRed : wellSpaceInputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: widget.showErrorBorder ? wellSpaceErrorRed : wellSpaceInputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: widget.showErrorBorder ? wellSpaceErrorRed : wellSpaceTeal600, width: 2.0),
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
      onChanged: widget.onChanged,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}