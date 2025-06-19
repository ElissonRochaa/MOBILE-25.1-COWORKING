class Usuario {
  String nome;
  String email;
  String? senha;
  DateTime? dataNascimento;
  String fotoPerfil;
  bool integridade;
  String? usuarioRole; 

  Usuario({
    required this.nome,
    required this.email,
    required this.senha,
    required this.dataNascimento,
    required this.fotoPerfil,
    this.integridade = false,
    this.usuarioRole, 
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
      'dataNascimento': dataNascimento?.toIso8601String(),
      'fotoPerfil': fotoPerfil,
      'integridade': integridade,
      'usuarioRole': usuarioRole, 
    };
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      senha: json['senha'],
      dataNascimento: json['dataNascimento'] != null
          ? DateTime.tryParse(json['dataNascimento'])
          : null,
      fotoPerfil: json['fotoPerfil'] ?? '',
      integridade: json['integridade'] ?? false,
      usuarioRole: json['usuarioRole'], 
    );
  }
}