// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import 'about_screen.dart';
import 'changelog_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $urlString';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo abrir el enlace: $urlString'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Configuración'),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // --- APARIENCIA ---
          _SectionHeader("Apariencia"),
          _SettingsCard(
            child: _SettingsTile(
              leading: Icon(
                Icons.dark_mode_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: 'Modo Oscuro',
              subtitle: 'Habilitado por defecto',
              trailing: Icon(
                Icons.check_circle_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              onTap: null, // No hace nada porque es fijo
            ),
          ),

          // --- DATOS Y SISTEMA ---
          _SectionHeader("Datos y Sistema"),
          _SettingsCard(
            child: Column(
              children: [
                _SettingsTile(
                  leading: const Icon(
                    Icons.system_update_alt_rounded,
                    color: Colors.lightBlueAccent,
                  ),
                  title: 'Buscar actualizaciones',
                  subtitle: 'Verificar nueva versión',
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.blue[200],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangelogScreen(),
                      ),
                    );
                  },
                ),
                Divider(height: 1, indent: 56, color: Colors.blueGrey.shade900),
                _SettingsTile(
                  leading: const Icon(
                    Icons.sync_rounded,
                    color: Colors.lightBlueAccent,
                  ),
                  title: 'Sincronizar catálogo',
                  subtitle: 'Forzar recarga de datos',
                  trailing: Icon(
                    Icons.refresh_rounded,
                    color: Colors.blue[200],
                  ),
                  onTap: () {
                    ref.invalidate(allDataProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sincronizando catálogo...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                Divider(height: 1, indent: 56, color: Colors.blueGrey.shade900),
                _SettingsTile(
                  leading: const Icon(
                    Icons.delete_sweep_rounded,
                    color: Colors.lightBlueAccent,
                  ),
                  title: 'Limpiar caché',
                  subtitle: 'Liberar espacio',
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.blue[200],
                  ),
                  onTap: () async {
                    final bool? didConfirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmar'),
                        content: const Text(
                          '¿Borrar las imágenes guardadas? Se volverán a descargar si las necesitas.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Borrar'),
                          ),
                        ],
                      ),
                    );

                    if (didConfirm == true) {
                      await DefaultCacheManager().emptyCache();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Caché borrado correctamente'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),

          // --- COMUNIDAD ---
          _SectionHeader("Comunidad"),
          _SettingsCard(
            child: Column(
              children: [
                _SettingsTile(
                  leading: const Icon(
                    Icons.discord,
                    color: Color(0xFF5865F2),
                  ),
                  title: 'Discord Oficial',
                  subtitle: 'Únete a la conversación',
                  trailing: const Icon(
                    Icons.open_in_new_rounded,
                    size: 18,
                    color: Colors.grey,
                  ),
                  onTap: () => _launchUrl(
                    context,
                    'https://discord.com/invite/5sqFs8K',
                  ),
                ),
                Divider(height: 1, indent: 56, color: Colors.blueGrey.shade900),
                _SettingsTile(
                  leading: const Icon(
                    Icons.public,
                    color: Colors.lightBlueAccent,
                  ),
                  title: 'Sitio Web',
                  subtitle: 'Visita unlimitedsubs',
                  trailing: const Icon(
                    Icons.open_in_new_rounded,
                    size: 18,
                    color: Colors.grey,
                  ),
                  onTap: () => _launchUrl(
                    context,
                    'https://subsunlimiteds.com/', // ¡PON TU LINK AQUÍ!
                  ),
                ),
              ],
            ),
          ),

          // --- SOPORTE ---
          _SectionHeader("Soporte"),
          _SettingsCard(
            child: Column(
              children: [
                _SettingsTile(
                  leading: const Icon(
                    Icons.bug_report_rounded,
                    color: Colors.orangeAccent,
                  ),
                  title: 'Reportar un problema',
                  subtitle: 'Enviar correo a soporte',
                  onTap: () {
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: 'unlimitedsubs2@gmail.com',
                      query: 'subject=Bug Report - App v1.0.0',
                    );
                    _launchUrl(context, emailUri.toString());
                  },
                ),
                Divider(height: 1, indent: 56, color: Colors.blueGrey.shade900),
                _SettingsTile(
                  leading: const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.lightBlueAccent,
                  ),
                  title: 'Acerca de',
                  subtitle: 'Créditos y versión',
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.blue[200],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// -------------------
// WIDGETS DE ESTILO
// -------------------

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;

  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        // Usamos el color de tarjeta definido en el tema
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        // Borde sutil para dar efecto premium
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(16), child: child),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.leading,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          Colors.grey[400], // Color más suave para subtítulos
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: 8), trailing!],
          ],
        ),
      ),
    );
  }
}
