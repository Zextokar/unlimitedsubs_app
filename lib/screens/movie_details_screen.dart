// lib/screens/movie_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/pelicula.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';
import 'player_screen.dart';
import 'details_screen.dart';
import '../widgets/content_card.dart';

class MovieDetailsScreen extends ConsumerWidget {
  final Pelicula pelicula;

  const MovieDetailsScreen({
    super.key,
    required this.pelicula,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(pelicula.id);
    final allDataAsync = ref.watch(allDataProvider);
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // -------------------------------------------------------------------
          // HEADER 16:9 — DISEÑO TIPO NETFLIX
          // -------------------------------------------------------------------
          SliverAppBar(
            expandedHeight: size.width * (9 / 16), // 16/9 PERFECTO
            pinned: true,
            backgroundColor: Colors.black,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite
                      ? Icons.bookmark_added_rounded
                      : Icons.bookmark_add_outlined,
                  size: 26,
                ),
                onPressed: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(pelicula.id);
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Imagen principal 16/9 sin distorsión
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: pelicula.poster,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: Colors.grey[900]),
                      errorWidget: (_, __, ___) => Container(color: Colors.grey),
                    ),
                  ),

                  // Gradiente superior e inferior tipo Netflix
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black,
                        ],
                        stops: [0, 0.25, 0.7, 1],
                      ),
                    ),
                  ),

                  // Título centrado en la parte baja
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        pelicula.titleEN,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // -------------------------------------------------------------------
          // CONTENIDO — INFORMACIÓN Y BOTONES TIPO NETFLIX
          // -------------------------------------------------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags: Año, calidad, rating
                  Row(
                    children: [
                      _NetflixTag(pelicula.releaseDate2),
                      const SizedBox(width: 8),
                      _NetflixTag(pelicula.quality),
                      const SizedBox(width: 8),
                      _NetflixTag("⭐ ${pelicula.rating}"),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // BOTÓN REPRODUCIR — Netflix White Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlayerScreen(
                              videoUrl: pelicula.movieURL,
                              videoTitle: pelicula.titleEN,
                              videoHash: pelicula.movieHash,
                              itemId: pelicula.id,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow_rounded, size: 28),
                          SizedBox(width: 6),
                          Text(
                            "Reproducir",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // BOTÓN MI LISTA
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        ref.read(favoritesProvider.notifier).toggleFavorite(pelicula.id);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        // ignore: deprecated_member_use
                        side: BorderSide(color: Colors.white.withOpacity(0.6)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isFavorite ? Icons.check_rounded : Icons.add_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "Mi lista",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // SINOPSIS
                  Text(
                    pelicula.synopsis,
                    style: textTheme.bodyLarge?.copyWith(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.85),
                      height: 1.35,
                      fontSize: 15.5,
                    ),
                  ),

                  const SizedBox(height: 38),

                  // -----------------------------------------------------------------
                  // RELACIONADOS — CARRUSEL HORIZONTAL 16/9 TIPO NETFLIX
                  // -----------------------------------------------------------------
                  if (pelicula.relationsSeries.isNotEmpty)
                    Text(
                      "Relacionado con",
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),

                  const SizedBox(height: 14),

                  allDataAsync.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (allData) {
                      final allSeries = [
                        ...allData.superSentai,
                        ...allData.kamenRider,
                        ...allData.ultraman,
                        ...allData.garoSeries,
                        ...allData.offTopic,
                      ];

                      final related = allSeries.where((serie) {
                        return pelicula.relationsSeries.any(
                          (r) => r.relationSerieID == serie.id,
                        );
                      }).toList();

                      if (related.isEmpty) {
                        return Text(
                          "No se encontró la serie relacionada.",
                          style: TextStyle(color: Colors.grey[400]),
                        );
                      }

                      return SizedBox(
                        height: 150,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: related.length,
                          padding: const EdgeInsets.only(right: 12),
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final serie = related[index];
                            return SizedBox(
                              width: 200, // RELACIONADOS 16/9
                              child: ContentCard(
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
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

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

// ---------------------------------------------------------------------------
// ESTILO TAG NETFLIX
// ---------------------------------------------------------------------------
class _NetflixTag extends StatelessWidget {
  final String text;

  const _NetflixTag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white.withOpacity(0.15),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
