import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dotted_border/dotted_border.dart';
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

  Future<void> selecionarImagem() async {
    final XFile? xfile = await picker.pickImage(source: ImageSource.gallery);
    if (xfile != null) {
      if (await xfile.length() <= 10 * 1024 * 1024) { // 10 MB
        final bytes = await xfile.readAsBytes();
        setState(() {
          previewImageBytes.add(bytes);
          previewFileNames.add(xfile.name);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione uma imagem com até 10MB.')),
        );
      }
    }
  }

  Future<void> enviarImagens() async {
    final vm = Provider.of<SalaImagemViewModel>(context, listen: false);
    bool houveFalha = false;
    for (int i = 0; i < previewImageBytes.length; i++) {
      bool ok = await vm.uploadImagemBytes(widget.salaId, previewImageBytes[i], previewFileNames[i]);
      if (!ok) houveFalha = true;
    }
    setState(() {
      previewImageBytes.clear();
      previewFileNames.clear();
    });

    if (houveFalha) {
      if (vm.errorMsg != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(vm.errorMsg!)),
        );
      }
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
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
                            onTap: vm.isUploading ? null : selecionarImagem,
                            child: Text(
                              "Clique para adicionar uma imagem",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor
                              ),
                            ),
                          ),
                          const Text("PNG, JPG ou JPEG (MAX. 10MB)", style: TextStyle(fontSize: 15, color: Colors.black54)),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
