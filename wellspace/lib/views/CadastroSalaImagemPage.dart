import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart'; // NOVO IMPORTANTE
import '../viewmodels/SalaImagemViewModel.dart';

class CadastroSalaImagemPage extends StatefulWidget {
  final String salaId;
  const CadastroSalaImagemPage({required this.salaId, Key? key}) : super(key: key);

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

  Future<void> selecionarImagens() async {
    final List<XFile>? xfiles = await picker.pickMultiImage();
    if (xfiles != null && xfiles.isNotEmpty) {
      List<Uint8List> bytesList = [];
      List<String> namesList = [];
      for (var xfile in xfiles) {
        if (await xfile.length() > 10 * 1024 * 1024) continue; // ignora >10MB
        bytesList.add(await xfile.readAsBytes());
        namesList.add(xfile.name);
      }
      setState(() {
        previewImageBytes = bytesList;
        previewFileNames = namesList;
      });
    }
  }

  Future<void> enviarImagens() async {
    final vm = Provider.of<SalaImagemViewModel>(context, listen: false);
    for (int i = 0; i < previewImageBytes.length; i++) {
      await vm.uploadImagemBytes(widget.salaId, previewImageBytes[i], previewFileNames[i]);
    }
    setState(() {
      previewImageBytes.clear();
      previewFileNames.clear();
    });
    if (vm.errorMsg != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMsg!)),
      );
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
    return Consumer<SalaImagemViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text('Cadastro de Imagens', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
          ),
          body: Center(
            child: Container(
              width: 700,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Cadastro de Imagens', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text(
                    'Adicione fotos de alta qualidade do seu espaço de coworking para atrair mais clientes.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 32),
                  DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    dashPattern: const [8, 4],
                    color: Colors.grey[300]!,
                    strokeWidth: 2,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: vm.isUploading ? null : selecionarImagens,
                            child: Text(
                              "Clique para fazer upload",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor
                              ),
                            ),
                          ),
                          const Text("ou arraste e solte", style: TextStyle(fontSize: 18, color: Colors.black54)),
                          const SizedBox(height: 8),
                          const Text("PNG, JPG ou JPEG (MAX. 10MB)", style: TextStyle(fontSize: 15, color: Colors.black54)),
                          const Text(
                            "Recomendamos pelo menos 5 fotos de alta qualidade",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 14),
                          if (previewImageBytes.isEmpty)
                            const Text(
                              "Nenhuma imagem selecionada",
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          if (previewImageBytes.isNotEmpty)
                            Wrap(
                              spacing: 8,
                              children: List.generate(
                                previewImageBytes.length,
                                (idx) => Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey[300]!),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.memory(previewImageBytes[idx], fit: BoxFit.cover),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          previewImageBytes.removeAt(idx);
                                          previewFileNames.removeAt(idx);
                                        });
                                      },
                                      child: CircleAvatar(
                                        radius: 13,
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.close, color: Colors.red, size: 20),
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          previewImageBytes.isEmpty
                              ? 'Nenhuma imagem selecionada'
                              : '${previewImageBytes.length} imagem(ns) selecionada(s)',
                          style: const TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ),
                      TextButton(
                        onPressed: previewImageBytes.isEmpty ? null : limparTudo,
                        child: const Text("Limpar tudo"),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.upload_file),
                        label: const Text("Salvar imagens"),
                        onPressed: (previewImageBytes.isEmpty || vm.isUploading)
                            ? null
                            : enviarImagens,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue[600],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Voltar'),
                      ),
                      ElevatedButton(
                        onPressed: () {/* Implemente a lógica do próximo passo */},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[100],
                          foregroundColor: Colors.blue[900],
                        ),
                        child: const Text('Próximo'),
                      ),
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
