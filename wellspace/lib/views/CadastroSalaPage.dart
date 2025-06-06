import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/CadastroSalaViewModel.dart';
import '../viewmodels/SalaImagemViewModel.dart';
import 'CadastroSalaImagemPage.dart';
import '../views/widgets/sideMenu.dart';

class CadastroSalaPage extends StatefulWidget {
  @override
  State<CadastroSalaPage> createState() => _CadastroSalaPageState();
}

class _CadastroSalaPageState extends State<CadastroSalaPage> {
  final CadastroSalaViewModel viewModel = CadastroSalaViewModel();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController _controllerHorarioInicio;
  late TextEditingController _controllerHorarioFim;

  @override
  void initState() {
    super.initState();
    _controllerHorarioInicio = TextEditingController(
      text: _formatTimeOfDay(viewModel.disponibilidadeInicio),
    );
    _controllerHorarioFim = TextEditingController(
      text: _formatTimeOfDay(viewModel.disponibilidadeFim),
    );
  }

  @override
  void dispose() {
    _controllerHorarioInicio.dispose();
    _controllerHorarioFim.dispose();
    super.dispose();
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final h = tod.hour.toString().padLeft(2, '0');
    final m = tod.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _selecionarHorarioInicio() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: viewModel.disponibilidadeInicio,
    );
    if (picked != null) {
      setState(() {
        viewModel.disponibilidadeInicio = picked;
        _controllerHorarioInicio.text = _formatTimeOfDay(picked);
      });
    }
  }

  Future<void> _selecionarHorarioFim() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: viewModel.disponibilidadeFim,
    );
    if (picked != null) {
      setState(() {
        viewModel.disponibilidadeFim = picked;
        _controllerHorarioFim.text = _formatTimeOfDay(picked);
      });
    }
  }

  Future<void> _salvarSala() async {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      final salaCadastrada = await viewModel.cadastrarSala(context);
      if (salaCadastrada != null &&
          salaCadastrada.id != null &&
          salaCadastrada.id!.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => SalaImagemViewModel(),
              child: CadastroSalaImagemPage(salaId: salaCadastrada.id!),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao cadastrar sala!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos obrigatórios.'),
        ),
      );
    }
  }

  void _voltarParaHome() {
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  bool mostrarDias = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: const Text('Cadastro de Sala'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informações Básicas da Sala',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nome da Sala',
                  hintText: 'Ex: Sala Executiva 01',
                  helperText: 'Um nome único e descritivo para a sala',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe o nome da sala'
                    : null,
                onSaved: (value) => viewModel.nomeSala = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tamanho da Sala',
                  hintText: 'Ex: 20m²',
                  helperText: 'Informe o tamanho da sala em metros quadrados',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o tamanho' : null,
                onSaved: (value) => viewModel.tamanho = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Descreva a sala em detalhes...',
                  helperText:
                      'Forneça uma descrição detalhada da sala, incluindo equipamentos e recursos disponíveis',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe a descrição'
                    : null,
                onSaved: (value) => viewModel.descricao = value ?? '',
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Disponibilidade da Sala',
                  border: OutlineInputBorder(),
                  helperText: 'Selecione o status de disponibilidade',
                ),
                value: viewModel.disponibilidadeSala.isNotEmpty
                    ? viewModel.disponibilidadeSala
                    : null,
                items: ['DISPONIVEL', 'INDISPONIVEL', 'RESERVADA']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      viewModel.disponibilidadeSala = value;
                    });
                  }
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Selecione a disponibilidade'
                    : null,
                onSaved: (value) => viewModel.disponibilidadeSala = value ?? '',
              ),
              const SizedBox(height: 32),
              const Text(
                'Preços e Horários',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Preço por Hora (R\$)',
                  hintText: 'R\$ 0,00',
                  helperText: 'Valor por hora',
                  border: OutlineInputBorder(),
                  prefixText: 'R\$ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe um valor';
                  final val = double.tryParse(value.replaceAll(',', '.'));
                  if (val == null || val <= 0)
                    return 'Informe um valor positivo';
                  return null;
                },
                onSaved: (value) => viewModel.precoHora = value ?? '',
              ),
              const SizedBox(height: 24),
              StatefulBuilder(
                builder: (context, setStateLocal) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            mostrarDias = !mostrarDias;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Dias Disponíveis na Semana',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Icon(
                              mostrarDias
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (mostrarDias)
                        Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            'Seg',
                            'Ter',
                            'Qua',
                            'Qui',
                            'Sex',
                            'Sab',
                            'Dom',
                          ].map((dia) {
                            return SizedBox(
                              width:
                                  (MediaQuery.of(context).size.width - 96) / 2,
                              child: CheckboxListTile(
                                dense: true,
                                visualDensity: VisualDensity.compact,
                                title: Text(
                                  dia,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                value: viewModel.diasDisponiveis.contains(dia),
                                onChanged: (bool? selecionado) {
                                  setState(() {
                                    if (selecionado == true) {
                                      viewModel.diasDisponiveis.add(dia);
                                    } else {
                                      viewModel.diasDisponiveis.remove(dia);
                                    }
                                  });
                                  setStateLocal(() {});
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _controllerHorarioInicio,
                      decoration: const InputDecoration(
                        labelText: 'Horário Início',
                        helperText: 'Hora de início da disponibilidade',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      onTap: _selecionarHorarioInicio,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _controllerHorarioFim,
                      decoration: const InputDecoration(
                        labelText: 'Horário Fim',
                        helperText: 'Hora final da disponibilidade',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      onTap: _selecionarHorarioFim,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Voltar para Home'),
                      onPressed: _voltarParaHome,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue[700],
                        side: BorderSide(color: Colors.blue[700]!),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Próximo'),
                      onPressed: _salvarSala,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
