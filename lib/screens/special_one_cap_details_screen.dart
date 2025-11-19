import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/especial_one_cap.dart';
// ignore: unused_import
import '../models/serie.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';
import 'player_screen.dart';
import 'details_screen.dart';
import '../widgets/content_card.dart';

class SpecialOneCapDetailsScreen extends ConsumerWidget {
  final EspecialOneCap especial;

  const SpecialOneCapDetailsScreen({super.key, required this.especial});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(especial.id);
    final allDataAsync = ref.watch(allDataProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // -------------------------
          // NETFLIX HEADER 16:9
          // -------------------------
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Colors.black,
            actions: [
              // FAVORITO ESTILO NETFLIX
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.bookmark : Icons.bookmark_border,
                  size: 28,
                ),
                onPressed: () {
                  ref
                      .read(favoritesProvider.notifier)
                      .toggleFavorite(especial.id);
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // IMAGEN 16:9
                  CachedNetworkImage(
                    imageUrl: especial.poster,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: Colors.grey.shade900),
                  ),

                  // GRADIENTE ESTILO NETFLIX
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.85),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // -------------------------
          // CONTENIDO
          // -------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // TÍTULO ESTILO NETFLIX
                  Text(
                    especial.titleEN,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // DATOS EN BADGES
                  Row(
                    children: [
                      _InfoBadge(especial.releaseDate2),
                      const SizedBox(width: 8),
                      _InfoBadge(especial.quality),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amberAccent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        especial.rating.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // -------------------------
                  // BOTÓN REPRODUCIR TIPO NETFLIX
                  // -------------------------
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.play_arrow, size: 30),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      label: const Text(
                        "Reproducir",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlayerScreen(
                              videoUrl: especial.movieURL,
                              videoTitle: especial.titleEN,
                              videoHash: especial.movieHash,
                              itemId: especial.id,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 26),

                  // -------------------------
                  // SINOPSIS
                  // -------------------------
                  const Text(
                    "Sinopsis",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    especial.synopsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      height: 1.4,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // -------------------------
                  // SECCIÓN: RELACIONADOS
                  // -------------------------
                  if (especial.relationsSeries.isNotEmpty) ...[
                    const Text(
                      "Relacionado con",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),

                    allDataAsync.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                      error: (_, __) => const SizedBox(),
                      data: (allData) {
                        final allSeries = [
                          ...allData.superSentai,
                          ...allData.kamenRider,
                          ...allData.ultraman,
                          ...allData.garoSeries,
                          ...allData.offTopic,
                        ];

                        final relatedSeriesList = allSeries.where((serie) {
                          return especial.relationsSeries.any(
                            (rel) => rel.relationSerieID == serie.id,
                          );
                        }).toList();

                        if (relatedSeriesList.isEmpty) {
                          return const Text(
                            "No se encontró la serie relacionada.",
                            style: TextStyle(color: Colors.grey),
                          );
                        }

                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: relatedSeriesList.map((serie) {
                            return ContentCard(
                              title: serie.titleEN,
                              imageUrl: serie.poster,
                              aspectRatio: 16 / 9,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailsScreen(serie: serie),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------
// BADGE DE INFORMACIÓN
// -----------------------------------------------------
class _InfoBadge extends StatelessWidget {
  final String text;

  const _InfoBadge(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
