// lib/screens/changelog_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/changelog_service.dart';
import '../services/app_version_provider.dart';

class ChangelogScreen extends ConsumerWidget {
  const ChangelogScreen({super.key});

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

  // --- ¡FUNCIÓN DE LIMPIEZA NUEVA! ---
  // Esta función elimina la 'v', los espacios y cualquier cosa después del '+'
  String _cleanVersion(String version) {
    // 1. Quita la 'v' o 'V'
    String clean = version.replaceAll(RegExp(r'[vV]'), '');
    // 2. Quita el número de compilación (ej: 1.0.0+2 -> 1.0.0)
    if (clean.contains('+')) {
      clean = clean.split('+')[0];
    }
    // 3. Quita espacios
    return clean.trim();
  }
  // --- FIN FUNCIÓN ---

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final changelogAsync = ref.watch(changelogProvider);
    final localVersionAsync = ref.watch(appVersionProvider);

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        // Título dinámico
        title: changelogAsync.when(
          data: (release) => Text('Versión ${release.tagName}'),
          loading: () => const Text('Cargando...'),
          error: (_, __) => const Text('Error'),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
      ),
      body: changelogAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Error al cargar el changelog:\n$e',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
          ),
        ),
        data: (release) {
          return localVersionAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) =>
                Center(child: Text("Error obteniendo versión local: $e")),
            data: (localVersion) {
              // --- COMPARACIÓN ROBUSTA ---
              final String cleanLocal = _cleanVersion(localVersion);
              final String cleanRemote = _cleanVersion(release.tagName);

              final bool isLatest = cleanLocal == cleanRemote;
              // ---------------------------

              return ListView(
                padding: const EdgeInsets.all(20.0),
                children: [
                  // 🔵 CAJA PRINCIPAL
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      color: isLatest
                          ? Colors.green.withOpacity(
                              0.15,
                            ) // Verde si está actualizado
                          : Colors.blueAccent.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isLatest ? Colors.green : Colors.lightBlueAccent,
                        width: 1.3,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLatest
                              ? '¡Todo actualizado!'
                              : 'Nueva versión disponible: ${release.tagName}',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: isLatest ? Colors.green : Colors.blue[300],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          // Mostramos la versión limpia para que se vea igual
                          'Tu versión instalada: $cleanLocal',
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 16),

                        FilledButton.icon(
                          onPressed: () {
                            _launchUrl(context, release.htmlUrl);
                          },
                          icon: Icon(
                            isLatest
                                ? Icons.open_in_new
                                : Icons.download_rounded,
                            size: 18,
                          ),
                          label: Text(
                            isLatest
                                ? 'Ver en GitHub'
                                : 'Descargar actualización',
                          ),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: isLatest
                                ? Colors.green
                                : Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  Text(
                    'Novedades en esta versión',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[200],
                    ),
                  ),
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: colors.surfaceContainerHighest.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: MarkdownBody(
                      data: release.body,
                      styleSheet:
                          MarkdownStyleSheet.fromTheme(
                            Theme.of(context),
                          ).copyWith(
                            p: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontSize: 15,
                              height: 1.55,
                            ),
                            listBullet: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontSize: 15,
                              height: 1.55,
                            ),
                            h2: TextStyle(
                              color: Colors.blue[200],
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
