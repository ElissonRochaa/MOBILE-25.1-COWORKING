class Usuario {
  String nome;
  String email;
  String senha;
  DateTime dataNascimento;
  String fotoPerfil;
  bool integridade; 

  Usuario({
    required this.nome,
    required this.email,
    required this.senha,
    required this.dataNascimento,
    required this.fotoPerfil,
    this.integridade = false,
  });


  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha, 
      'dataNascimento': dataNascimento.toIso8601String(),
      'fotoPerfil': fotoPerfil,
      'integridade': integridade,
    };
  }
}
