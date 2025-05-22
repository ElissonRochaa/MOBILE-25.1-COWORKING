import 'package:flutter/material.dart';
import 'package:Wellspace/models/Sala.dart';
import 'package:Wellspace/services/SalaImagesService.dart';

class SalaCard extends StatefulWidget {
  final Sala sala;

  const SalaCard({super.key, required this.sala});

  @override
  State<SalaCard> createState() => _SalaCardState();
}

class _SalaCardState extends State<SalaCard> {
  String? imageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImagem();
  }

  Future<void> _loadImagem() async {
    setState(() {
      isLoading = true;
    });
    try {
      final String idParaServico = widget.sala.id.toString();
      print('[SalaCard] Sala ID sendo usada para a requisição: $idParaServico');
      final List<String> urlsRecebidas =
          await SalaImagemService.listarImagensPorSala(idParaServico);

      print('[SalaCard] URLs recebidas do serviço: $urlsRecebidas');

      if (mounted) {
        setState(() {
          if (urlsRecebidas.isNotEmpty) {
            imageUrl = urlsRecebidas.first;
          } else {
            imageUrl = null;
            print(
                '[SalaCard] Nenhuma URL de imagem recebida para a sala ID: $idParaServico');
          }
          print('[SalaCard] URL da imagem definida para o card: $imageUrl');
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('[SalaCard] Erro ao carregar imagem no SalaCard: $e');
      print('[SalaCard] Stack Trace: $stackTrace');
      if (mounted) {
        setState(() {
          isLoading = false;
          imageUrl = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 130,
                width: double.infinity,
                color: Colors.grey[300],
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : imageUrl != null && imageUrl!.isNotEmpty
                        ? Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                  '[SalaCard] Erro ao carregar imagem da rede ($imageUrl): $error');
                              return Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 40,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Icon(
                              Icons.meeting_room,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                          ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.sala.disponibilidadeSala,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.sala.nomeSala,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.sala.descricao,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.aspect_ratio, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Tamanho: ${widget.sala.tamanho}',
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${widget.sala.disponibilidadeDiaSemana} (${widget.sala.disponibilidadeInicio} - ${widget.sala.disponibilidadeFim})',
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'R\$ ${widget.sala.precoHora.toStringAsFixed(2)}/hora',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/alugar',
                            arguments: widget.sala);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Ver Detalhes'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
