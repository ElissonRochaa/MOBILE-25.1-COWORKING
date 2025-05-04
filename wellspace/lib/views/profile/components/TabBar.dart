import 'package:flutter/material.dart';

class TabSelector extends StatelessWidget {
  final int selectedTab;
  final Function(int) onTabChanged;

  const TabSelector(
      {super.key, required this.selectedTab, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    final tabs = ['Informações', 'Verificação', 'Favoritos', 'Reservas'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(tabs.length, (index) {
        final selected = selectedTab == index;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTabChanged(index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selected ? Colors.grey[200] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                tabs[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
