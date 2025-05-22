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
  String disponibilidadeDiaSemana = '';
  TimeOfDay disponibilidadeInicio = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay disponibilidadeFim = TimeOfDay(hour: 18, minute: 0);
  String disponibilidadeSala = 'DISPONIVEL'; 
  String usuarioId = '';

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
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
      print('[carregarUsuarioId] usuarioId carregado: "$usuarioId"');
      return usuarioId.isNotEmpty;
    } catch (e) {
      print('[carregarUsuarioId] Erro ao carregar usuarioId: $e');
      usuarioId = '';
      return false;
    }
  }

  
  Future<Sala?> cadastrarSala(BuildContext context) async {
    print('[cadastrarSala] Iniciando cadastro da sala');

    final carregou = await carregarUsuarioId();
    if (!carregou) {
      _showSnackBar(context, 'Usuário não autenticado. Faça login novamente.', isError: true);
      print('[cadastrarSala] Falha: usuário não autenticado');
      return null;
    }
    print('[cadastrarSala] usuarioId para cadastro: $usuarioId');

    final preco = double.tryParse(precoHora.replaceAll(',', '.')) ?? 0;
    if (preco <= 0) {
      _showSnackBar(context, 'Informe um preço por hora válido e maior que zero.', isError: true);
      print('[cadastrarSala] Falha: preço inválido');
      return null;
    }

    final String inicioStr =
        '${disponibilidadeInicio.hour.toString().padLeft(2, '0')}:${disponibilidadeInicio.minute.toString().padLeft(2, '0')}:00';
    final String fimStr =
        '${disponibilidadeFim.hour.toString().padLeft(2, '0')}:${disponibilidadeFim.minute.toString().padLeft(2, '0')}:00';

    final dispoValida = ['DISPONIVEL', 'INDISPONIVEL', 'RESERVADA'].contains(disponibilidadeSala);
    if (!dispoValida) {
      _showSnackBar(context, 'Disponibilidade da sala inválida.', isError: true);
      print('[cadastrarSala] Falha: disponibilidade inválida');
      return null;
    }

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

    print('[cadastrarSala] Sala objeto: ${sala.toJson()}');

    try {
      final salaCadastrada = await SalaService.cadastrarSala(sala);
      if (salaCadastrada != null && salaCadastrada.id != null && salaCadastrada.id!.isNotEmpty) {
        _showSnackBar(context, 'Sala cadastrada com sucesso!');
        print('[cadastrarSala] Sucesso no cadastro: salaId=${salaCadastrada.id}');
        return salaCadastrada;
      } else {
        _showSnackBar(context, 'Erro ao cadastrar sala', isError: true);
        print('[cadastrarSala] Erro: salaCadastrada retornou null');
        return null;
      }
    } catch (e) {
      _showSnackBar(context, 'Erro na comunicação com o servidor', isError: true);
      print('[cadastrarSala] Exception: $e');
      return null;
    }
  }
}
