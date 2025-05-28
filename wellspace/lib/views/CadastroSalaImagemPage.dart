import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';
import '../viewmodels/SalaImagemViewModel.dart';

class CadastroSalaImagemPage extends StatefulWidget {
  final String salaId;
  const CadastroSalaImagemPage({required this.salaId, Key? key})
      : super(key: key);

  @override
  State<CadastroSalaImagemPage> createState() => _CadastroSalaImagemPageState();
}

class _CadastroSalaImagemPageState extends State<CadastroSalaImagemPage> {
  final picker = ImagePicker();
  List<Uint8List> previewImageBytes = [];
  List<String> previewFileNames = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<SalaImagemViewModel>(context, listen: false)
        .listarImagensPorSala(widget.salaId);
  }

  Future<void> selecionarImagem() async {
    final ThemeData theme = Theme.of(context);
    final XFile? xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile != null) {
      if (await xfile.length() <= 10 * 1024 * 1024) {
        // 10MB
        final bytes = await xfile.readAsBytes();
        setState(() {
          previewImageBytes.add(bytes);
          previewFileNames.add(xfile.name);
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Selecione uma imagem com até 10MB.'),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  Future<void> enviarImagens() async {
    final ThemeData theme = Theme.of(context);
    final vm = Provider.of<SalaImagemViewModel>(context, listen: false);
    bool houveFalha = false;

    for (int i = 0; i < previewImageBytes.length; i++) {
      bool ok = await vm.uploadImagemBytes(
          widget.salaId, previewImageBytes[i], previewFileNames[i]);
      if (!ok) houveFalha = true;
    }

    if (mounted) {
      setState(() {
        previewImageBytes.clear();
        previewFileNames.clear();
      });

      if (houveFalha) {
        if (vm.errorMsg != null && vm.errorMsg!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(vm.errorMsg!),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'Ocorreu uma falha ao enviar uma ou mais imagens.'),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Imagens salvas com sucesso!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false);
      }
    }
  }

  void limparTudo() {
    setState(() {
      previewImageBytes.clear();
      previewFileNames.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Consumer<SalaImagemViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          appBar: AppBar(
            title: const Text('Cadastro de Imagens'),
          ),
          body: Center(
            child: Container(
              width: 700,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cadastro de Imagens da Sala',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Adicione fotos de alta qualidade do seu espaço de coworking para atrair mais clientes.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 32),
                  DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    dashPattern: const [8, 4],
                    color: theme.colorScheme.outline.withOpacity(0.7),
                    strokeWidth: 2,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:
                            theme.colorScheme.surfaceVariant.withOpacity(0.5),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 32, horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined,
                              size: 64,
                              color: theme.colorScheme.onSurfaceVariant
                                  .withOpacity(0.8)),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: vm.isUploading ? null : selecionarImagem,
                            child: Text(
                              "Clique para adicionar uma imagem",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text("PNG, JPG ou JPEG (MAX. 10MB)",
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant)),
                          const SizedBox(height: 24),
                          if (previewImageBytes.isEmpty && !vm.isUploading)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Text(
                                "Nenhuma imagem selecionada",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant),
                              ),
                            ),
                          if (vm.isUploading)
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 8),
                                  Text("Enviando imagens..."),
                                ],
                              ),
                            ),
                          if (previewImageBytes.isNotEmpty && !vm.isUploading)
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: List.generate(
                                previewImageBytes.length,
                                (idx) => Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 5, right: 5),
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: theme.colorScheme.outline),
                                          image: DecorationImage(
                                            image: MemoryImage(
                                                previewImageBytes[idx]),
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            previewImageBytes.removeAt(idx);
                                            previewFileNames.removeAt(idx);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                              color: theme.cardColor
                                                  .withOpacity(0.8),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  blurRadius: 3,
                                                )
                                              ]),
                                          child: Icon(Icons.close_rounded,
                                              color: theme.colorScheme.error,
                                              size: 20),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          previewImageBytes.isEmpty && !vm.isUploading
                              ? 'Nenhuma imagem para upload'
                              : '${previewImageBytes.length} imagem(ns) pronta(s) para upload',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          if (previewImageBytes.isNotEmpty && !vm.isUploading)
                            TextButton(
                              onPressed: limparTudo,
                              child: Text("Limpar tudo",
                                  style: TextStyle(
                                      color: theme.colorScheme.error)),
                            ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            icon: vm.isUploading
                                ? Container(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: theme.colorScheme.onPrimary))
                                : const Icon(Icons.upload_file),
                            label: Text(vm.isUploading
                                ? "Enviando..."
                                : "Salvar imagens"),
                            onPressed:
                                (previewImageBytes.isEmpty || vm.isUploading)
                                    ? null
                                    : enviarImagens,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              disabledBackgroundColor:
                                  theme.colorScheme.onSurface.withOpacity(0.12),
                              disabledForegroundColor:
                                  theme.colorScheme.onSurface.withOpacity(0.38),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              textStyle: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
