import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/Sala.dart';
import '../services/SalaService.dart';

class CadastroSalaViewModel {
  final _storage = const FlutterSecureStorage();

  String nomeSala = '';
  String descricao = '';
  String tamanho = '';
  String precoHora = '';
  List<String> diasDisponiveis = [];
  TimeOfDay disponibilidadeInicio = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay disponibilidadeFim = TimeOfDay(hour: 18, minute: 0);
  String disponibilidadeSala = 'DISPONIVEL';
  String usuarioId = '';

  void _showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<bool> carregarUsuarioId() async {
    try {
      usuarioId = await _storage.read(key: 'usuario_id') ?? '';
      return usuarioId.isNotEmpty;
    } catch (e) {
      usuarioId = '';
      return false;
    }
  }

  Future<Sala?> cadastrarSala(BuildContext context) async {
    final carregou = await carregarUsuarioId();
    if (!carregou) {
      _showSnackBar(context, 'Usuário não autenticado. Faça login novamente.',
          isError: true);
      return null;
    }

    final preco = double.tryParse(precoHora.replaceAll(',', '.')) ?? 0;
    if (preco <= 0) {
      _showSnackBar(
          context, 'Informe um preço por hora válido e maior que zero.',
          isError: true);
      return null;
    }

    final inicioStr =
        '${disponibilidadeInicio.hour.toString().padLeft(2, '0')}:${disponibilidadeInicio.minute.toString().padLeft(2, '0')}:00';
    final fimStr =
        '${disponibilidadeFim.hour.toString().padLeft(2, '0')}:${disponibilidadeFim.minute.toString().padLeft(2, '0')}:00';

    final dispoValida =
        ['DISPONIVEL', 'INDISPONIVEL'].contains(disponibilidadeSala);
    if (!dispoValida) {
      _showSnackBar(context, 'Disponibilidade da sala inválida.',
          isError: true);
      return null;
    }

    final disponibilidadeDiaSemana = diasDisponiveis.join(', ');

    final sala = Sala(
      nomeSala: nomeSala,
      descricao: descricao,
      tamanho: tamanho,
      precoHora: preco,
      disponibilidadeDiaSemana: disponibilidadeDiaSemana,
      disponibilidadeInicio: inicioStr,
      disponibilidadeFim: fimStr,
      disponibilidadeSala: disponibilidadeSala,
      usuarioId: usuarioId,
    );

    try {
      final salaCadastrada = await SalaService.cadastrarSala(sala);
      if (salaCadastrada != null &&
          salaCadastrada.id != null &&
          salaCadastrada.id!.isNotEmpty) {
        _showSnackBar(context, 'Sala cadastrada com sucesso!');
        return salaCadastrada;
      } else {
        _showSnackBar(context, 'Erro ao cadastrar sala', isError: true);
        return null;
      }
    } catch (e) {
      _showSnackBar(context, 'Erro na comunicação com o servidor',
          isError: true);
      return null;
    }
  }
}
