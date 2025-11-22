// lib/screens/library_specials_one_cap_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../widgets/content_card.dart';
import '../widgets/shimmer_placeholders.dart';
import 'special_one_cap_details_screen.dart';
import '../models/especial_one_cap.dart';

class LibrarySpecialsOneCapScreen extends ConsumerWidget {
  const LibrarySpecialsOneCapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allDataAsync = ref.watch(allDataProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[800]!, width: 1),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    // ignore: deprecated_member_use
                    colorScheme.primary.withOpacity(0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                "Especiales (Unitarios)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),

      body: allDataAsync.when(
        loading: () => const GridScreenSkeleton(),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: Colors.white),
          ),
        ),

        data: (allData) {
          final allSpecials = allData.specials.specialOneCap;

          if (allSpecials.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.movie_creation_outlined,
                    size: 80,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay especiales disponibles',
                    style: TextStyle(color: Colors.grey[500], fontSize: 16),
                  ),
                ],
              ),
            );
          }

          // --- LÓGICA DE AGRUPACIÓN ---
          final Map<String, List<EspecialOneCap>> specialsBySeries = {};
          final List<EspecialOneCap> noRelationSpecials = [];

          // Mapa auxiliar: ID de Serie -> Título Real de la Serie
          final Map<String, String> seriesNames = {};

          for (var s in allData.superSentai) {
            seriesNames[s.id] = s.titleEN;
          }
          for (var s in allData.kamenRider) {
            seriesNames[s.id] = s.titleEN;
          }
          for (var s in allData.ultraman) {
            seriesNames[s.id] = s.titleEN;
          }
          for (var s in allData.garoSeries) {
            seriesNames[s.id] = s.titleEN;
          }
          for (var s in allData.offTopic) {
            seriesNames[s.id] = s.titleEN;
          }

          for (var especial in allSpecials) {
            // Si no tiene relaciones o es N/A
            if (especial.relationsSeries.isEmpty ||
                especial.relationsSeries.any(
                  (r) => r.relationSerieID == "N/A",
                )) {
              noRelationSpecials.add(especial);
              continue;
            }

            for (var relation in especial.relationsSeries) {
              final seriesId = relation.relationSerieID;
              if (seriesId == "N/A") continue;

              if (!specialsBySeries.containsKey(seriesId)) {
                specialsBySeries[seriesId] = [];
              }
              if (!specialsBySeries[seriesId]!.contains(especial)) {
                specialsBySeries[seriesId]!.add(especial);
              }
            }
          }

          // --- CONSTRUCCIÓN DE LA LISTA ORDENADA ---
          final List<Widget> sections = [];

          void addSectionIfExists(String seriesId) {
            if (specialsBySeries.containsKey(seriesId)) {
              // Usamos el nombre real si lo tenemos, si no, usamos el ID
              final title = seriesNames[seriesId] ?? seriesId;

              sections.add(
                _OneCapGroupSection(
                  title: title,
                  items: specialsBySeries[seriesId]!,
                ),
              );
              specialsBySeries.remove(seriesId);
            }
          }

          // 1. Recorremos las listas oficiales para mantener el orden canónico
          for (var s in allData.superSentai) {
            addSectionIfExists(s.id);
          }
          for (var s in allData.kamenRider) {
            addSectionIfExists(s.id);
          }
          for (var s in allData.ultraman) {
            addSectionIfExists(s.id);
          }
          for (var s in allData.garoSeries) {
            addSectionIfExists(s.id);
          }
          for (var s in allData.offTopic) {
            addSectionIfExists(s.id);
          }

          // 2. Si quedó algo en el mapa
          specialsBySeries.forEach((id, items) {
            String title = seriesNames[id] ?? id;

            if (title == id) {
              title = id
                  .split('-')
                  .map((word) {
                    if (word.isEmpty) return '';
                    return '${word[0].toUpperCase()}${word.substring(1)}';
                  })
                  .join(' ');
            }

            sections.add(_OneCapGroupSection(title: title, items: items));
          });

          // 3. Agregamos la sección "Sin relación" al final
          if (noRelationSpecials.isNotEmpty) {
            sections.add(
              _OneCapGroupSection(
                title: "Otros Especiales",
                items: noRelationSpecials,
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(children: sections),
          );
        },
      ),
    );
  }
}

// --- Widget Auxiliar para cada Sección (Título + Cuadrícula) ---
class _OneCapGroupSection extends StatelessWidget {
  final String title;
  final List<EspecialOneCap> items;

  const _OneCapGroupSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Wrap(
            spacing: 12.0,
            runSpacing: 16.0,
            children: items.map((especial) {
              return ContentCard(
                title: especial.titleEN,
                imageUrl: especial.poster,
                // Usamos el prefijo 'special_' para que coincida con el Hero de destino
                heroTag: 'special_one_${especial.id}',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SpecialOneCapDetailsScreen(especial: especial),
                    ),
                  );
                },
                aspectRatio: 16 / 9,
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 32.0),
      ],
    );
  }
}
