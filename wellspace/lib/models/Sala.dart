class Sala {
  final String? id; 
  final String nomeSala;
  final String descricao;
  final String tamanho;
  final double precoHora;
  final String disponibilidadeDiaSemana;
  final String disponibilidadeInicio;
  final String disponibilidadeFim;
  final String disponibilidadeSala;
  final String usuarioId;

  Sala({
    this.id, 
    required this.nomeSala,
    required this.descricao,
    required this.tamanho,
    required this.precoHora,
    required this.disponibilidadeDiaSemana,
    required this.disponibilidadeInicio,
    required this.disponibilidadeFim,
    required this.disponibilidadeSala,
    required this.usuarioId,
  });

  factory Sala.fromJson(Map<String, dynamic> json) {
    return Sala(
      id: json['salasId']?.toString(), 
      nomeSala: json['nomeSala'] ?? '',
      descricao: json['descricao'] ?? '',
      tamanho: json['tamanho'] ?? '',
      precoHora: (json['precoHora'] is num) ? (json['precoHora'] as num).toDouble() : 0.0,
      disponibilidadeDiaSemana: json['disponibilidadeDiaSemana'] ?? '',
      disponibilidadeInicio: json['disponibilidadeInicio'] ?? '',
      disponibilidadeFim: json['disponibilidadeFim'] ?? '',
      disponibilidadeSala: json['disponibilidadeSala'] ?? 'DISPONIVEL',
      usuarioId: json['usuarioId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomeSala': nomeSala,
      'descricao': descricao,
      'tamanho': tamanho,
      'precoHora': precoHora,
      'disponibilidadeDiaSemana': disponibilidadeDiaSemana,
      'disponibilidadeInicio': disponibilidadeInicio,
      'disponibilidadeFim': disponibilidadeFim,
      'disponibilidadeSala': disponibilidadeSala,
      'usuarioId': usuarioId,
    };
  }
}
