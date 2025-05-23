import 'package:flutter/material.dart';

class EspacoCard extends StatelessWidget {
  final String nome;
  final String localizacao;
  final String preco;
  final double avaliacao;
  final String tipo;

  const EspacoCard({
    Key? key,
    required this.nome,
    required this.localizacao,
    required this.preco,
    required this.avaliacao,
    required this.tipo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                  child: Icon(Icons.image, size: 40, color: Colors.white)),
            ),
            const SizedBox(height: 8),
            Text(nome, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(localizacao, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 4),
                Text('$avaliacao', style: const TextStyle(fontSize: 12)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(tipo, style: const TextStyle(fontSize: 10)),
                ),
              ],
            ),
            const Spacer(),
            Text(preco,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
