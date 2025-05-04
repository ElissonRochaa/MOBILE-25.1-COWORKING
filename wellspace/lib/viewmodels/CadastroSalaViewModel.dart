import 'package:flutter/material.dart';
import '../models/Sala.dart';
import '../services/SalaService.dart';

class CadastroSalaViewModel {
  final formKey = GlobalKey<FormState>();

  String nomeSala = '';
  String descricao = '';
  String tamanho = '';
  String precoHora = '';
  String disponibilidadeDiaSemana = '';
  TimeOfDay disponibilidadeInicio = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay disponibilidadeFim = TimeOfDay(hour: 18, minute: 0);
  String disponibilidadeSala = '';

  String? validarSenhas() {
    return null;
  }

  void _showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> cadastrarSala(BuildContext context) async {
    final form = formKey.currentState!;
    if (!form.validate()) return;
    form.save();

    final sala = Sala(
      nomeSala: nomeSala,
      descricao: descricao,
      tamanho: tamanho,
      precoHora: double.tryParse(precoHora) ?? 0,
      disponibilidadeDiaSemana: disponibilidadeDiaSemana,
      disponibilidadeInicio:
          '${disponibilidadeInicio.hour.toString().padLeft(2, '0')}:'
          '${disponibilidadeInicio.minute.toString().padLeft(2, '0')}:00',
      disponibilidadeFim:
          '${disponibilidadeFim.hour.toString().padLeft(2, '0')}:'
          '${disponibilidadeFim.minute.toString().padLeft(2, '0')}:00',
      disponibilidadeSala: disponibilidadeSala,
    );

    try {
      final success = await SalaService.cadastrarSala(sala);
      if (success) {
        _showSnackBar(context, 'Sala cadastrada com sucesso!');
      } else {
        _showSnackBar(context, 'Erro ao cadastrar sala', isError: true);
      }
    } catch (e) {
      _showSnackBar(context, 'Erro na comunicação com o servidor',
          isError: true);
    }
  }
}
