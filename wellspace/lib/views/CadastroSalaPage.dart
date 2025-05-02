import 'package:flutter/material.dart';
import '../models/sala.dart';
import '../services/salaService.dart';

class CadastroSalaPage extends StatefulWidget {
  @override
  _CadastroSalaPageState createState() => _CadastroSalaPageState();
}

class _CadastroSalaPageState extends State<CadastroSalaPage> {
  final _formKey = GlobalKey<FormState>();


  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _tamanhoController = TextEditingController();
  final _precoController = TextEditingController();
  final _dispSemanaController = TextEditingController();

  
  TimeOfDay _inicio = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _fim = TimeOfDay(hour: 18, minute: 0);

 
  String? _dispSala;
  final List<String> _opcoesDispSala = [
    'DISPONIVEL',
    'INDISPONIVEL',
  ];

  Future<void> _pickTime(bool isStart) async {
    final sel = await showTimePicker(
      context: context,
      initialTime: isStart ? _inicio : _fim,
    );
    if (sel != null) {
      setState(() {
        if (isStart) _inicio = sel;
        else _fim = sel;
      });
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _tamanhoController.dispose();
    _precoController.dispose();
    _dispSemanaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final azul = Colors.blue;
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Sala')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      
                      TextFormField(
                        controller: _nomeController,
                        decoration: InputDecoration(
                          labelText: 'Nome da Sala',
                          hintText: 'Ex: Sala 1',
                          border: OutlineInputBorder(),
                          helperText: 'Nome identificador da sala',
                        ),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Informe o nome da sala' : null,
                      ),
                      const SizedBox(height: 16),

                     
                      TextFormField(
                        controller: _descricaoController,
                        decoration: InputDecoration(
                          labelText: 'Descrição',
                          hintText: 'Ex: Sala de conferências',
                          border: OutlineInputBorder(),
                          helperText: 'Descrição detalhada da sala',
                        ),
                        maxLines: 3,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Informe a descrição' : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _tamanhoController,
                        decoration: InputDecoration(
                          labelText: 'Tamanho',
                          hintText: 'Ex: Grande',
                          border: OutlineInputBorder(),
                          helperText: 'Tamanho da sala (Pequena, Média, Grande)',
                        ),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Informe o tamanho' : null,
                      ),
                      const SizedBox(height: 16),

                   
                      TextFormField(
                        controller: _precoController,
                        decoration: InputDecoration(
                          labelText: 'Preço por Hora (R\$)',
                          hintText: 'Ex: 100.0',
                          border: OutlineInputBorder(),
                          helperText: 'Valor positivo em R\$',
                          prefixText: 'R\$ ',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          final val = double.tryParse(v ?? '');
                          if (val == null || val <= 0) {
                            return 'Informe um valor positivo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                 
                      TextFormField(
                        controller: _dispSemanaController,
                        decoration: InputDecoration(
                          labelText: 'Disponibilidade (Semana)',
                          hintText: 'Ex: Segunda a Sexta',
                          border: OutlineInputBorder(),
                          helperText: 'Dias em que a sala está disponível',
                        ),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Informe a disponibilidade' : null,
                      ),
                      const SizedBox(height: 16),

                 
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Início',
                                prefixIcon: Icon(Icons.access_time),
                                border: OutlineInputBorder(),
                                helperText: 'Horário de início',
                              ),
                              controller: TextEditingController(
                                text: _inicio.format(context),
                              ),
                              onTap: () => _pickTime(true),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Fim',
                                prefixIcon: Icon(Icons.access_time),
                                border: OutlineInputBorder(),
                                helperText: 'Horário de fim',
                              ),
                              controller: TextEditingController(
                                text: _fim.format(context),
                              ),
                              onTap: () => _pickTime(false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Estado da Sala',
                          border: OutlineInputBorder(),
                          helperText: 'Status atual da disponibilidade',
                        ),
                        value: _dispSala,
                        items: _opcoesDispSala
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _dispSala = v),
                        validator: (v) =>
                            (v == null) ? 'Selecione o estado da sala' : null,
                      ),
                      const SizedBox(height: 32),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.close),
                            label: Text('Cancelar'),
                            style: TextButton.styleFrom(
                              foregroundColor: azul,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            icon: Icon(Icons.save),
                            label: Text('Salvar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: azul,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final sala = Sala(
                                  nomeSala: _nomeController.text,
                                  descricao: _descricaoController.text,
                                  tamanho: _tamanhoController.text,
                                  precoHora:
                                      double.parse(_precoController.text),
                                  disponibilidadeDiaSemana:
                                      _dispSemanaController.text,
                                  disponibilidadeInicio:
                                      '${_inicio.hour.toString().padLeft(2, '0')}:${_inicio.minute.toString().padLeft(2, '0')}:00',
                                  disponibilidadeFim:
                                      '${_fim.hour.toString().padLeft(2, '0')}:${_fim.minute.toString().padLeft(2, '0')}:00',
                                  disponibilidadeSala: _dispSala!,
                                );
                                final success =
                                    await SalaService.cadastrarSala(sala);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(success
                                        ? 'Sala cadastrada com sucesso!'
                                        : 'Erro ao cadastrar sala'),
                                    backgroundColor: success
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
