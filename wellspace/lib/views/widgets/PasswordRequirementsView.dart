import 'package:flutter/material.dart';
import 'package:Wellspace/viewmodels/PasswordRecoveryViewModel.dart';

const Color wellSpaceGreen600 = Color(0xFF16A34A);
const Color wellSpaceErrorRed = Color(0xFFEF4444);
const Color wellSpaceMutedForeground = Color(0xFF6B7280);

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
        Text(
          "Requisitos da senha:",
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: wellSpaceMutedForeground, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6.0),
        ...requirements.map((req) {
          final bool isValid = req.isValid;
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              children: [
                Icon(
                  isValid ? Icons.check_circle : Icons.cancel_outlined,
                  color: isValid ? wellSpaceGreen600 : wellSpaceErrorRed,
                  size: 16.0,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    req.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: wellSpaceMutedForeground,
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