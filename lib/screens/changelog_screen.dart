// lib/screens/changelog_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ¡AÑADIDO!
import 'package:flutter_markdown/flutter_markdown.dart'; // ¡AÑADIDO!
import 'package:url_launcher/url_launcher.dart';
import '../services/changelog_service.dart'; // ¡AÑADIDO!

// --- ¡CAMBIO! Convertido a ConsumerWidget ---
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
  // --- ¡CAMBIO! Añadido WidgetRef ref ---
  Widget build(BuildContext context, WidgetRef ref) {
    // Observamos el nuevo provider
    final changelogAsync = ref.watch(changelogProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        // El título se actualiza solo cuando los datos cargan
        title: changelogAsync.when(
          data: (release) => Text('Versión ${release.tagName}'),
          loading: () => const Text('Cargando...'),
          error: (e, s) => const Text('Error'),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),

      // --- ¡CAMBIO! Usamos .when() para el body ---
      body: changelogAsync.when(
        // --- ESTADO DE CARGA ---
        loading: () => const Center(child: CircularProgressIndicator()),

        // --- ESTADO DE ERROR ---
        error: (e, s) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Error al cargar el changelog:\n$e',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
        ),

        // --- ESTADO DE ÉXITO ---
        data: (release) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Título y botón de descarga
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      release.tagName == 'Error'
                          ? 'No se pudo verificar la versión'
                          : 'Estás al día (v${release.tagName})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        // Usamos la URL que vino de la API
                        _launchUrl(context, release.htmlUrl);
                      },
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: const Text('Descargar desde GitHub'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // El Changelog
              Text(
                'Novedades en esta versión:',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // --- ¡CAMBIO! ---
              // Usamos el widget MarkdownBody para renderizar
              // el texto que viene de GitHub
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: MarkdownBody(
                  data: release.body, // ¡El texto markdown!
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                      .copyWith(
                        p: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 15,
                          height: 1.6,
                        ),
                        listBullet: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                ),
              ),
              // --- FIN CAMBIO ---
            ],
          );
        },
      ),
    );
  }
}
