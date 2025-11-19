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
    final changelogAsync = ref.watch(changelogProvider);
    final localVersionAsync = ref.watch(appVersionProvider);

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
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
              final bool isLatest = localVersion == release.tagName;

              return ListView(
                padding: const EdgeInsets.all(20.0),
                children: [
                  // 🔵 CAJA PRINCIPAL — Azul estilo Netflix PRO
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      color: isLatest
                          // ignore: deprecated_member_use
                          ? Colors.blue.withOpacity(0.15)
                          // ignore: deprecated_member_use
                          : Colors.blueAccent.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isLatest ? Colors.blue : Colors.lightBlueAccent,
                        width: 1.3,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLatest
                              ? 'Estás usando la última versión ($localVersion)'
                              : 'Nueva versión disponible: ${release.tagName}',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: isLatest
                                ? Colors.blue[700]
                                : Colors.blue[300],
                          ),
                        ),

                        if (!isLatest) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Tu versión instalada: $localVersion',
                            style: TextStyle(
                              color: Colors.blue[100],
                              fontSize: 14,
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        FilledButton.icon(
                          onPressed: () {
                            _launchUrl(context, release.htmlUrl);
                          },
                          icon: const Icon(Icons.download_rounded, size: 18),
                          label: Text(
                            isLatest
                                ? 'Reinstalar desde GitHub'
                                : 'Descargar actualización',
                          ),
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: isLatest
                                ? Colors.blue
                                : Colors.lightBlueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  // 🔵 TÍTULO "Novedades"
                  Text(
                    'Novedades en esta versión',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[200],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 🔵 CARD del Markdown
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
