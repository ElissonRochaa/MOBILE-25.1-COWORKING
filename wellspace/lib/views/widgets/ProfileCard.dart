import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Wellspace/viewmodels/UsuarioDetailViewModel.dart';
import 'package:Wellspace/models/Usuario.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UsuarioDetailViewModel>();
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    if (viewModel.usuario == null) {
      return const Center(child: Text("Carregando perfil..."));
    }
    Usuario usuario = viewModel.usuario!;

    Color integridadeBackgroundColor;
    Color integridadeBorderColor;
    Color integridadeTextColor;

    if (usuario.integridade) {
      integridadeBackgroundColor = isDarkMode
          ? Colors.green.shade700.withOpacity(0.25)
          : Colors.green.shade50;
      integridadeBorderColor =
          isDarkMode ? Colors.green.shade500 : Colors.green.shade200;
      integridadeTextColor =
          isDarkMode ? Colors.green.shade200 : Colors.green.shade900;
    } else {
      integridadeBackgroundColor = isDarkMode
          ? Colors.red.shade700.withOpacity(0.25)
          : Colors.red.shade50;
      integridadeBorderColor =
          isDarkMode ? Colors.red.shade500 : Colors.red.shade200;
      integridadeTextColor =
          isDarkMode ? Colors.red.shade200 : Colors.red.shade900;
    }

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: theme.cardColor,
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  backgroundImage: usuario.fotoPerfil.isNotEmpty
                      ? NetworkImage(usuario.fotoPerfil)
                      : null,
                  child: usuario.fotoPerfil.isEmpty
                      ? Icon(Icons.person_outline,
                          size: 50, color: theme.colorScheme.onSurfaceVariant)
                      : null,
                ),
                const SizedBox(height: 20),
                Text(
                  usuario.nome,
                  style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  usuario.email,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7)),
                ),
                const SizedBox(height: 20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      color: integridadeBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: integridadeBorderColor, width: 1)),
                  child: Text(
                    usuario.integridade
                        ? "Identidade verificada"
                        : "Não verificado",
                    style: TextStyle(
                        color: integridadeTextColor,
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
                        icon: Icons.calendar_today_outlined,
                        text:
                            "Nasc: ${usuario.dataNascimento!.day.toString().padLeft(2, '0')}/${usuario.dataNascimento!.month.toString().padLeft(2, '0')}/${usuario.dataNascimento!.year}",
                      ),
                    ],
                  ),
                if (usuario.dataNascimento != null) const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/editar-perfil');
                  },
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  label: const Text("Editar perfil",
                      style: TextStyle(fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    foregroundColor: theme.colorScheme.primary,
                    elevation: 1,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    side: BorderSide(
                        color: theme.colorScheme.primary.withOpacity(0.5)),
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
    final ThemeData theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            size: 18,
            color: theme.iconTheme.color?.withOpacity(0.7) ??
                theme.colorScheme.onSurface.withOpacity(0.7)),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.85)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
