import 'package:flutter/material.dart';
import 'package:Wellspace/viewmodels/PasswordRecoveryViewModel.dart';


const Color primaryBlue = Color(0xFF1976D2); 
const Color errorColor = Color(0xFFD32F2F); 
const Color textSecondary = Color(0xFF757575);

class PasswordRequirementsView extends StatelessWidget {
  final String password;
  final List<PasswordRequirement> requirements;

  const PasswordRequirementsView({
    super.key,
    required this.password,
    required this.requirements,
  });

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty && requirements.every((req) => !req.isValid)) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Text(
            "Requisitos da senha:",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: textSecondary, 
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        ...requirements.map((req) {
          final bool isValid = req.isValid;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0), 
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  isValid ? Icons.check_circle_outline : Icons.highlight_off_outlined, 
                  color: isValid ? primaryBlue : errorColor,
                  size: 18.0, 
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    req.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: textSecondary, 
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}