import 'package:flutter/material.dart';

class TabSelector extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;
  final List<String> tabs; // ESTA LINHA É CRÍTICA!

  const TabSelector({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
    required this.tabs, // ESTA LINHA É CRÍTICA!
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(tabs.length, (index) {
        final bool selected = selectedTab == index;

        Color backgroundColor;
        Color textColor;
        FontWeight fontWeight;

        if (selected) {
          backgroundColor = theme.colorScheme.primaryContainer;
          textColor = theme.colorScheme.onPrimaryContainer;
          fontWeight = FontWeight.bold;
        } else {
          backgroundColor = theme.colorScheme.surfaceVariant.withOpacity(0.5);
          textColor = theme.colorScheme.onSurfaceVariant;
          fontWeight = FontWeight.normal;
        }

        return Expanded(
          child: GestureDetector(
            onTap: () => onTabChanged(index),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onTabChanged(index),
                borderRadius: BorderRadius.circular(8),
                splashColor: theme.colorScheme.primary.withOpacity(0.12),
                highlightColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tabs[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: fontWeight,
                      color: textColor,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}