import 'package:flutter/material.dart';

class FavoritosTab extends StatelessWidget {
  const FavoritosTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Favoritos",
        style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
      ),
    );
  }
}
