class Usuario {
  String nome;
  String email;
  String senha;
  String confirmarSenha;
  DateTime dataNascimento;
  String fotoPerfil;

  Usuario({
    required this.nome,
    required this.email,
    required this.senha,
    required this.confirmarSenha,
    required this.dataNascimento,
    required this.fotoPerfil,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
      'confirmarSenha': confirmarSenha,
      'dataNascimento': dataNascimento.toIso8601String(),
      'fotoPerfil': fotoPerfil,
    };
  }
}
