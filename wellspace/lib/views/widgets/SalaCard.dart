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
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    if (widget.sala.id != null && widget.sala.id!.isNotEmpty) {
      _loadImagem();
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
          imageUrl = null;
        });
      }
      print(
          '[SalaCard] ID da sala é nulo ou vazio no initState. Nenhuma imagem será carregada.');
    }
  }

  @override
  void didUpdateWidget(covariant SalaCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.sala.id != oldWidget.sala.id) {
      if (widget.sala.id != null && widget.sala.id!.isNotEmpty) {
        _loadImagem();
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
            imageUrl = null;
          });
        }
        print(
            '[SalaCard] ID da sala atualizado para nulo ou vazio. Nenhuma imagem será carregada.');
      }
    }
  }

  Future<void> _loadImagem() async {
    if (!mounted || widget.sala.id == null || widget.sala.id!.isEmpty) {
      if (mounted) {
        setState(() {
          isLoading = false;
          imageUrl = null;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final String idParaServico = widget.sala.id!;
      print(
          '[SalaCard] Sala ID ($idParaServico) sendo usada para a requisição de imagem.');

      final List<String> urlsRecebidas =
          await SalaImagemService.listarImagensPorSala(idParaServico);

      print('[SalaCard] URLs recebidas para ($idParaServico): $urlsRecebidas');

      if (mounted) {
        setState(() {
          if (urlsRecebidas.isNotEmpty) {
            imageUrl = urlsRecebidas.first;
          } else {
            imageUrl = null;
          }
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('[SalaCard] Erro ao carregar imagem para (${widget.sala.id}): $e');
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
                    ? const Center(
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : imageUrl != null && imageUrl!.isNotEmpty
                        ? Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                  '[SalaCard] Erro ao carregar imagem da rede ($imageUrl): $error');
                              return Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
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
                                  strokeWidth: 2.5,
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
                              widget.sala.id == null || widget.sala.id!.isEmpty
                                  ? Icons.image_not_supported_outlined
                                  : Icons.meeting_room_outlined,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                          ),
              ),
              if (widget.sala.disponibilidadeSala.isNotEmpty)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.sala.disponibilidadeSala.toUpperCase() ==
                              "DISPONIVEL"
                          ? const Color.fromARGB(255, 47, 47, 47)
                              .withOpacity(0.85)
                          : (widget.sala.disponibilidadeSala.toUpperCase() ==
                                  "INDISPONIVEL"
                              ? Colors.red.withOpacity(0.85)
                              : Colors.orange.withOpacity(0.85)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.sala.disponibilidadeSala,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: isFavorited ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorited = !isFavorited;
                    });
                    print(
                        '[SalaCard] Sala "${widget.sala.nomeSala}" favoritada: $isFavorited');
                  },
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
                    fontSize: 17,
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
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.square_foot_outlined,
                        size: 15, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Tamanho: ${widget.sala.tamanho}',
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_month_outlined,
                        size: 15, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${widget.sala.disponibilidadeDiaSemana} (${widget.sala.disponibilidadeInicio} - ${widget.sala.disponibilidadeFim})',
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'R\$ ${widget.sala.precoHora.toStringAsFixed(2)}/hora',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (widget.sala.id != null &&
                            widget.sala.id!.isNotEmpty) {
                          Navigator.pushNamed(context, '/alugar',
                              arguments: widget.sala.id);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'ID da sala indisponível para ver detalhes.'),
                            ),
                          );
                          print(
                              '[SalaCard] Botão "Ver Detalhes": ID da sala é nulo ou vazio.');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      child: const Text('Ver Detalhes'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
