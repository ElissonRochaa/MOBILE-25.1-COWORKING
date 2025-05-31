import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF1976D2); 
const Color pageBackground = Colors.white;
const Color cardBackground = Colors.white;
const Color textPrimary = Color(0xFF212121);
const Color textSecondary = Color(0xFF757575); 
class FormCardLayout extends StatelessWidget {
  final Widget iconWidget;
  final String title;
  final String description;
  final Widget child;
  final PreferredSizeWidget? appBar;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;

  const FormCardLayout({
    super.key,
    required this.iconWidget,
    required this.title,
    required this.description,
    required this.child,
    this.appBar,
    this.titleStyle,
    this.descriptionStyle,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle defaultTitleStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ) ??
        const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        );

    final TextStyle defaultDescriptionStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: textSecondary,
        ) ??
        const TextStyle(
          fontSize: 14,
          color: textSecondary,
        );

    return Scaffold(
      appBar: appBar, 
      backgroundColor: pageBackground, 
      body: Center( 
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            color: cardBackground, // Cor do card
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  iconWidget, 
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: titleStyle ?? defaultTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  if (description.isNotEmpty)
                    Text(
                      description,
                      style: descriptionStyle ?? defaultDescriptionStyle,
                      textAlign: TextAlign.center,
                    ),
                  if (description.isNotEmpty)
                     const SizedBox(height: 24),
                  if (description.isEmpty)
                      const SizedBox(height: 12),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}