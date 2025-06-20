class Favorito {
  final String favoritoId;
  final String usuarioId;
  final String salaId;

  Favorito({
    required this.favoritoId,
    required this.usuarioId,
    required this.salaId,
  });

  factory Favorito.fromJson(Map<String, dynamic> json) {
    return Favorito(
      favoritoId: json['favoritoId'],
      usuarioId: json['usuarioId'],
      salaId: json['salaId'],
    );
  }
}
