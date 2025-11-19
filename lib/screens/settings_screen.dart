// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:unlimitedsubs_app/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import 'about_screen.dart';
import 'changelog_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
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
    final ThemeMode currentThemeMode = ref.watch(themeModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent,
                    Colors.lightBlueAccent.withOpacity(0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Configuración',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // APARIENCIA
          _SectionHeader("Apariencia"),
          _SettingsCard(
            child: Column(
              children: [
                _SettingsTile(
                  leading: Icon(
                    currentThemeMode == ThemeMode.dark
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    color: Colors.blueAccent,
                  ),
                  title: 'Modo Oscuro',
                  subtitle: 'Habilitar el tema oscuro de la aplicación',
                  trailing: Switch(
                    value: currentThemeMode == ThemeMode.dark,
                    activeThumbColor: Colors.blueAccent,
                    onChanged: (bool isDark) {
                      themeNotifier.state = isDark
                          ? ThemeMode.dark
                          : ThemeMode.light;
                    },
                  ),
                ),
              ],
            ),
          ),

          // DATOS Y ACTUALIZACIÓN
          _SectionHeader("Datos y Actualización"),
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
                  title: 'Actualizar contenido',
                  subtitle: 'Sincronizar catálogos y datos',
                  trailing: Icon(
                    Icons.refresh_rounded,
                    color: Colors.blue[200],
                  ),
                  onTap: () {
                    ref.invalidate(allDataProvider);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('Actualizando contenido...'),
                          ],
                        ),
                        backgroundColor: Colors.blueGrey.shade900,
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
                  subtitle: 'Borra imágenes guardadas',
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.blue[200],
                  ),
                  onTap: () async {
                    final bool? didConfirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.black,
                        icon: const Icon(
                          Icons.delete_sweep_rounded,
                          size: 32,
                          color: Colors.lightBlueAccent,
                        ),
                        title: const Text(
                          'Limpiar caché',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: Text(
                          '¿Deseas borrar todo el caché? Las imágenes se volverán a descargar.',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.lightBlueAccent,
                            ),
                            child: const Text('Borrar'),
                          ),
                        ],
                      ),
                    );

                    if (didConfirm == true) {
                      await DefaultCacheManager().emptyCache();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 12),
                                const Text('Caché eliminado correctamente'),
                              ],
                            ),
                            backgroundColor: Colors.blueAccent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),

          // INFORMACIÓN
          _SectionHeader("Información"),
          _SettingsCard(
            child: Column(
              children: [
                _SettingsTile(
                  leading: const Icon(
                    Icons.chat_bubble_rounded,
                    color: Colors.lightBlueAccent,
                  ),
                  title: 'Enviar comentarios',
                  subtitle: 'Comparte sugerencias o reporta errores',
                  trailing: Icon(
                    Icons.open_in_new_rounded,
                    size: 18,
                    color: Colors.blue[200],
                  ),
                  onTap: () {
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: 'unlimitedsubs2@gmail.com',
                      query: 'subject=Feedback UnlimitedSubs v1.0.0',
                    );
                    _launchUrl(context, emailUri.toString());
                  },
                ),

                Divider(height: 1, indent: 56, color: Colors.blueGrey.shade900),

                _SettingsTile(
                  leading: const Icon(
                    Icons.code_rounded,
                    color: Colors.lightBlueAccent,
                  ),
                  title: 'Licencias de código',
                  subtitle: 'Bibliotecas de código abierto',
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.blue[200],
                  ),
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: 'UnlimitedSubs',
                      applicationVersion: '1.0.0',
                    );
                  },
                ),

                Divider(height: 1, indent: 56, color: Colors.blueGrey.shade900),

                _SettingsTile(
                  leading: const Icon(
                    Icons.info_rounded,
                    color: Colors.lightBlueAccent,
                  ),
                  title: 'Acerca de',
                  subtitle: 'Información y créditos',
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.blue[200],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutScreen(),
                      ),
                    );
                  },
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
// ESTILO VISUAL
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
          color: Colors.blueAccent,
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueGrey.shade900),
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
      splashColor: Colors.blueAccent.withOpacity(0.12),
      highlightColor: Colors.blueAccent.withOpacity(0.06),
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
                    style: TextStyle(fontSize: 14, color: Colors.blueGrey[300]),
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
