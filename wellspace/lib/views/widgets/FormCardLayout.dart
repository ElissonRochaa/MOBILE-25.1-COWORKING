import 'package:flutter/material.dart';

const Color wellSpaceTeal50 = Color(0xFFF0FDFA);
const Color wellSpaceBlue50 = Color(0xFFEFF6FF);
const Color wellSpaceCardBackground = Colors.white;
const Color wellSpaceForeground = Color(0xFF1F2937);
const Color wellSpaceMutedForeground = Color(0xFF6B7280);

class FormCardLayout extends StatelessWidget {
  final Widget iconWidget;
  final String title;
  final String description;
  final Widget child;
  final PreferredSizeWidget? appBar;

  const FormCardLayout({
    super.key,
    required this.iconWidget,
    required this.title,
    required this.description,
    required this.child,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    iconWidget,
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: wellSpaceForeground,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: wellSpaceMutedForeground),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    child,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}