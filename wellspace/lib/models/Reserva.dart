import 'package:Wellspace/models/Sala.dart';

class UsuarioInfo {
  final String id;
  final String nome;

  UsuarioInfo({required this.id, required this.nome});

  factory UsuarioInfo.fromJson(Map<String, dynamic> json) {
    return UsuarioInfo(
      id: json['usuarioId']?.toString() ?? '',
      nome: json['nome'] ?? 'Nome não informado',
    );
  }
}

class Reserva {
  final String id;
  final String dataReserva;
  final String horaInicio;
  final String horaFim;
  final double valorTotal;
  final String statusReserva;
  final Sala sala;
  final UsuarioInfo locatario;
  final UsuarioInfo locador;

  Reserva({
    required this.id,
    required this.dataReserva,
    required this.horaInicio,
    required this.horaFim,
    required this.valorTotal,
    required this.statusReserva,
    required this.sala,
    required this.locatario,
    required this.locador,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['reservaId']?.toString() ?? '',
      dataReserva: json['dataReserva'] ?? '',
      horaInicio: json['horaInicio'] ?? '',
      horaFim: json['horaFim'] ?? '',
      valorTotal: (json['valorTotal'] as num?)?.toDouble() ?? 0.0,
      statusReserva: json['statusReserva'] ?? 'PENDENTE',
      sala: Sala.fromJson(json['salas'] ?? {}),
      locatario: UsuarioInfo.fromJson(json['locatario'] ?? {}),
      locador: UsuarioInfo.fromJson(json['locador'] ?? {}),
    );
  }
}

class ReservaRequest {
  final String dataReserva;
  final String horaInicio;
  final String horaFim;
  final String salasId;
  final String locatarioId;
  final String locadorId;

  ReservaRequest({
    required this.dataReserva,
    required this.horaInicio,
    required this.horaFim,
    required this.salasId,
    required this.locatarioId,
    required this.locadorId,
  });

  Map<String, dynamic> toJson() {
    return {
      'dataReserva': dataReserva,
      'horaInicio': horaInicio,
      'horaFim': horaFim,
      'salas': salasId,
      'locatario': locatarioId,
      'locador': locadorId,
    };
  }
}
