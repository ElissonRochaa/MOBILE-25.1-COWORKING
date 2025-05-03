

class Sala {
  String nomeSala;
  String descricao;
  String tamanho;
  double precoHora;
  String disponibilidadeDiaSemana;
  String disponibilidadeInicio;
  String disponibilidadeFim;   
  String disponibilidadeSala;   

  Sala({
    required this.nomeSala,
    required this.descricao,
    required this.tamanho,
    required this.precoHora,
    required this.disponibilidadeDiaSemana,
    required this.disponibilidadeInicio,
    required this.disponibilidadeFim,
    required this.disponibilidadeSala,
  });

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
    };
  }
}
