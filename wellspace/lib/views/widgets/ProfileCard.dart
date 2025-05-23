import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wellspace/viewmodels/UsuarioDetailViewModel.dart';
import 'package:Wellspace/models/Usuario.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UsuarioDetailViewModel>();

    Usuario usuario = viewModel.usuario!;
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: const Color(0xFFF9F4FC),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: usuario.fotoPerfil.isNotEmpty
                      ? NetworkImage(usuario.fotoPerfil)
                      : null,
                  child: usuario.fotoPerfil.isEmpty
                      ? const Icon(Icons.person, size: 45, color: Colors.white)
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  usuario.nome,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  usuario.email,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      color: usuario.integridade
                          ? Colors.green[50]
                          : Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: usuario.integridade
                              ? Colors.green.shade200
                              : Colors.red.shade200,
                          width: 1)),
                  child: Text(
                    usuario.integridade
                        ? "Identidade verificada"
                        : "Não verificado",
                    style: TextStyle(
                        color: usuario.integridade
                            ? Colors.green[800]
                            : Colors.red[800],
                        fontWeight: FontWeight.w500,
                        fontSize: 13),
                  ),
                ),
                const SizedBox(height: 28),
                if (usuario.dataNascimento != null)
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 24,
                    runSpacing: 12,
                    children: [
                      _InfoItem(
                        icon: Icons.calendar_today,
                        text:
                            "Nasc: ${usuario.dataNascimento!.day.toString().padLeft(2, '0')}/${usuario.dataNascimento!.month.toString().padLeft(2, '0')}/${usuario.dataNascimento!.year}",
                      ),
                    ],
                  ),
                if (usuario.dataNascimento != null) const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Funcionalidade de editar perfil ainda não implementada.')),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 20),
                  label: const Text("Editar perfil",
                      style: TextStyle(fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    side: BorderSide(
                        color: Theme.of(context).primaryColor.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14.5),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
