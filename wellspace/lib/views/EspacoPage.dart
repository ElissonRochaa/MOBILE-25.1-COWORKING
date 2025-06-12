import 'package:Wellspace/views/widgets/SalaCard.dart';
import 'package:Wellspace/views/widgets/sideMenu.dart';
import 'package:flutter/material.dart';
import '../models/Sala.dart';
import '../viewmodels/SalaListViewModel.dart';

enum OpcaoOrdenacao {
  nenhuma,
  precoCrescente,
  precoDecrescente,
  nomeCrescente,
}

class EspacosPage extends StatefulWidget {
  const EspacosPage({super.key});

  @override
  State<EspacosPage> createState() => _EspacosPageState();
}

class _EspacosPageState extends State<EspacosPage> {
  bool exibirMapa = false;
  final SalaListViewModel salaListViewModel = SalaListViewModel();
  String searchQuery = '';
  final _searchController = TextEditingController();

  OpcaoOrdenacao _opcaoOrdenacao = OpcaoOrdenacao.nenhuma;
  double? _filtroPrecoMaximo;
  List<String> _filtroDiasSemana = [];
  double _precoMinimoGeral = 0;
  double _precoMaximoGeral = 1000;

  bool _didProcessInitialArgs = false;

  @override
  void initState() {
    super.initState();
    salaListViewModel.carregarSalas().then((_) {
      if (mounted) {
        _calcularFaixaDePreco();
        setState(() {});
      }
    });
  }

  void _calcularFaixaDePreco() {
    if (salaListViewModel.salas.isEmpty) return;
    double min = salaListViewModel.salas.first.precoHora;
    double max = salaListViewModel.salas.first.precoHora;
    for (var sala in salaListViewModel.salas) {
      if (sala.precoHora < min) min = sala.precoHora;
      if (sala.precoHora > max) max = sala.precoHora;
    }
    setState(() {
      _precoMinimoGeral = min;
      _precoMaximoGeral = max;
      _filtroPrecoMaximo = max;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didProcessInitialArgs) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments is String && arguments.isNotEmpty) {
        setState(() {
          searchQuery = arguments;
          _searchController.text = arguments;
        });
      }
      _didProcessInitialArgs = true;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _filtrosAtivos {
    bool precoFiltrado =
        _filtroPrecoMaximo != null && _filtroPrecoMaximo! < _precoMaximoGeral;
    bool diasFiltrados = _filtroDiasSemana.isNotEmpty;
    return precoFiltrado || diasFiltrados;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    List<Sala> salasProcessadas = salaListViewModel.salas;

    if (searchQuery.isNotEmpty) {
      salasProcessadas = salasProcessadas.where((sala) {
        return sala.nomeSala.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    if (_filtroPrecoMaximo != null) {
      salasProcessadas = salasProcessadas
          .where((sala) => sala.precoHora <= _filtroPrecoMaximo!)
          .toList();
    }
    if (_filtroDiasSemana.isNotEmpty) {
      salasProcessadas = salasProcessadas.where((sala) {
        final diasDisponiveisNaSala =
            sala.disponibilidadeDiaSemana.toLowerCase();
        for (String filtroSelecionado in _filtroDiasSemana) {
          final filtroLower = filtroSelecionado.toLowerCase();
          if (filtroLower == "todos os dias") {
            return true;
          }
          if (filtroLower == "segunda a sexta") {
            if (diasDisponiveisNaSala.contains("seg") ||
                diasDisponiveisNaSala.contains("ter") ||
                diasDisponiveisNaSala.contains("qua") ||
                diasDisponiveisNaSala.contains("qui") ||
                diasDisponiveisNaSala.contains("sex")) {
              return true;
            }
          } else if (diasDisponiveisNaSala.contains(filtroLower)) {
            return true;
          }
        }
        return false;
      }).toList();
    }

    switch (_opcaoOrdenacao) {
      case OpcaoOrdenacao.precoCrescente:
        salasProcessadas.sort((a, b) => a.precoHora.compareTo(b.precoHora));
        break;
      case OpcaoOrdenacao.precoDecrescente:
        salasProcessadas.sort((a, b) => b.precoHora.compareTo(a.precoHora));
        break;
      case OpcaoOrdenacao.nomeCrescente:
        salasProcessadas.sort((a, b) =>
            a.nomeSala.toLowerCase().compareTo(b.nomeSala.toLowerCase()));
        break;
      case OpcaoOrdenacao.nenhuma:
        break;
    }

    return Scaffold(
      drawer: SideMenu(),
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Text('Todos os Espaços'),
      ),
      body: Column(
        children: [
          _buildSearchBar(context, theme, isDarkMode),
          _buildActionButtons(context, theme, isDarkMode),
          _buildEspacosEncontrados(context, theme, salasProcessadas.length),
          Expanded(
            child: exibirMapa
                ? _buildMapaPlaceholder(context, theme, isDarkMode)
                : _buildListaEspacos(context, theme, salasProcessadas),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(
      BuildContext context, ThemeData theme, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => searchQuery = value),
        style: TextStyle(color: theme.colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: 'Buscar por nome',
          hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          prefixIcon:
              Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
          filled: true,
          fillColor: isDarkMode
              ? theme.colorScheme.surfaceVariant.withOpacity(0.5)
              : Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: theme.colorScheme.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, ThemeData theme, bool isDarkMode) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.surfaceVariant,
      foregroundColor: theme.colorScheme.onSurfaceVariant,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    final ButtonStyle activeFilterButtonStyle = buttonStyle.copyWith(
      backgroundColor:
          MaterialStateProperty.all(theme.colorScheme.primaryContainer),
      foregroundColor:
          MaterialStateProperty.all(theme.colorScheme.onPrimaryContainer),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: _exibirDialogoDeFiltros,
            icon: Icon(
              Icons.filter_list,
              size: 18,
              color: _filtrosAtivos
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
            label: Text('Filtros'),
            style: _filtrosAtivos ? activeFilterButtonStyle : buttonStyle,
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: _exibirOpcoesDeOrdenacao,
            icon: const Icon(Icons.sort, size: 18),
            label: const Text('Ordenar por'),
            style: buttonStyle,
          ),
          const Spacer(),
          IconButton(
            onPressed: () => setState(() => exibirMapa = false),
            icon: Icon(Icons.view_list,
                color: !exibirMapa
                    ? theme.colorScheme.primary
                    : theme.iconTheme.color),
            tooltip: 'Visualizar em lista',
          ),
          IconButton(
            onPressed: () => setState(() => exibirMapa = true),
            icon: Icon(Icons.location_on,
                color: exibirMapa
                    ? theme.colorScheme.primary
                    : theme.iconTheme.color),
            tooltip: 'Visualizar no mapa',
          ),
        ],
      ),
    );
  }

  void _exibirOpcoesDeOrdenacao() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.arrow_upward),
              title: Text('Preço (menor para maior)'),
              onTap: () {
                setState(() => _opcaoOrdenacao = OpcaoOrdenacao.precoCrescente);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.arrow_downward),
              title: Text('Preço (maior para menor)'),
              onTap: () {
                setState(
                    () => _opcaoOrdenacao = OpcaoOrdenacao.precoDecrescente);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.sort_by_alpha),
              title: Text('Nome (A-Z)'),
              onTap: () {
                setState(() => _opcaoOrdenacao = OpcaoOrdenacao.nomeCrescente);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.clear),
              title: Text('Remover Ordenação'),
              onTap: () {
                setState(() => _opcaoOrdenacao = OpcaoOrdenacao.nenhuma);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _exibirDialogoDeFiltros() {
    double tempPrecoMaximo = _filtroPrecoMaximo ?? _precoMaximoGeral;
    List<String> tempDiasSemana = List.from(_filtroDiasSemana);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final diasDisponiveis = [
              "Segunda a Sexta",
              "Sab",
              "Dom",
              "Todos os dias"
            ];

            return AlertDialog(
              title: Text('Filtros'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Preço máximo por hora: R\$ ${tempPrecoMaximo.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyLarge),
                    Slider(
                      min: _precoMinimoGeral,
                      max: _precoMaximoGeral,
                      value: tempPrecoMaximo,
                      divisions: 20,
                      label: 'R\$ ${tempPrecoMaximo.toStringAsFixed(2)}',
                      onChanged: (value) {
                        setDialogState(() {
                          tempPrecoMaximo = value;
                        });
                      },
                    ),
                    Divider(),
                    Text('Dias da semana:',
                        style: Theme.of(context).textTheme.bodyLarge),
                    ...diasDisponiveis.map((dia) {
                      return CheckboxListTile(
                        title: Text(dia),
                        value: tempDiasSemana.contains(dia),
                        onChanged: (bool? value) {
                          setDialogState(() {
                            if (value == true) {
                              tempDiasSemana.add(dia);
                            } else {
                              tempDiasSemana.remove(dia);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Limpar'),
                  onPressed: () {
                    setDialogState(() {
                      tempPrecoMaximo = _precoMaximoGeral;
                      tempDiasSemana.clear();
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('Aplicar'),
                  onPressed: () {
                    setState(() {
                      _filtroPrecoMaximo = tempPrecoMaximo;
                      _filtroDiasSemana = tempDiasSemana;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEspacosEncontrados(
      BuildContext context, ThemeData theme, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('$count espaços encontrados',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onBackground)),
      ),
    );
  }

  Widget _buildListaEspacos(
      BuildContext context, ThemeData theme, List<Sala> salas) {
    if (salaListViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (salaListViewModel.errorMessage != null) {
      return Center(
          child: Text(salaListViewModel.errorMessage!,
              style: TextStyle(color: theme.colorScheme.error)));
    }
    if (salas.isEmpty) {
      return Center(
          child: Text('Nenhum espaço encontrado com esses critérios',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.onBackground)));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      itemCount: salas.length,
      itemBuilder: (context, index) {
        return _buildSalaCard(salas[index]);
      },
    );
  }

  Widget _buildSalaCard(Sala sala) {
    return SalaCard(sala: sala);
  }

  Widget _buildMapaPlaceholder(
      BuildContext context, ThemeData theme, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Icon(Icons.map, size: 60, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text("Mapa do Google será integrado aqui",
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text("Mostrando espaços",
                style: TextStyle(
                    color:
                        theme.colorScheme.onSurfaceVariant.withOpacity(0.7))),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
