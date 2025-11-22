// lib/screens/library_movies_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../widgets/content_card.dart';
import '../widgets/shimmer_placeholders.dart';
import 'movie_details_screen.dart';
import '../models/pelicula.dart';
// Importamos serie para usar el modelo si es necesario

class LibraryMoviesScreen extends ConsumerWidget {
  const LibraryMoviesScreen({super.key});

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
                "Películas",
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
          // --- ¡CAMBIO AQUÍ! ---
          // Combinamos las listas Y filtramos las que tienen "N/A"
          final allMovies = [
            ...allData.movies.movieCrossover,
            ...allData.movies.movieWinterSerie,
          // ignore: unnecessary_null_comparison
          ].where((m) => m.movieURL != null && m.movieURL != "N/A").toList();
          // --- FIN CAMBIO ---

          if (allMovies.isEmpty) {
            return const Center(child: Text('No hay películas disponibles'));
          }

          // --- LÓGICA DE AGRUPACIÓN ---
          final Map<String, List<Pelicula>> moviesBySeries = {};
          final List<Pelicula> noRelationMovies = [];

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

          for (var movie in allMovies) {
            if (movie.relationsSeries.isEmpty ||
                movie.relationsSeries.any((r) => r.relationSerieID == "N/A")) {
              noRelationMovies.add(movie);
              continue;
            }

            for (var relation in movie.relationsSeries) {
              final seriesId = relation.relationSerieID;
              if (seriesId == "N/A") continue;

              if (!moviesBySeries.containsKey(seriesId)) {
                moviesBySeries[seriesId] = [];
              }
              if (!moviesBySeries[seriesId]!.contains(movie)) {
                moviesBySeries[seriesId]!.add(movie);
              }
            }
          }

          // --- CONSTRUCCIÓN DE LA LISTA ORDENADA ---
          final List<Widget> sections = [];

          void addSectionIfExists(String seriesId, String title) {
            if (moviesBySeries.containsKey(seriesId)) {
              final displayTitle = seriesNames[seriesId] ?? title;

              sections.add(
                _MovieGroupSection(
                  title: displayTitle,
                  movies: moviesBySeries[seriesId]!,
                ),
              );
              moviesBySeries.remove(seriesId);
            }
          }

          for (var s in allData.superSentai) {
            addSectionIfExists(s.id, s.titleEN);
          }
          for (var s in allData.kamenRider) {
            addSectionIfExists(s.id, s.titleEN);
          }
          for (var s in allData.ultraman) {
            addSectionIfExists(s.id, s.titleEN);
          }
          for (var s in allData.garoSeries) {
            addSectionIfExists(s.id, s.titleEN);
          }
          for (var s in allData.offTopic) {
            addSectionIfExists(s.id, s.titleEN);
          }

          moviesBySeries.forEach((id, movies) {
            String title = seriesNames[id] ?? id;
            if (title == id) {
              title = id
                  .split('-')
                  .map(
                    (word) => word.isNotEmpty
                        ? '${word[0].toUpperCase()}${word.substring(1)}'
                        : '',
                  )
                  .join(' ');
            }
            sections.add(_MovieGroupSection(title: title, movies: movies));
          });

          if (noRelationMovies.isNotEmpty) {
            sections.add(
              _MovieGroupSection(
                title: "Otras Películas",
                movies: noRelationMovies,
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

class _MovieGroupSection extends StatelessWidget {
  final String title;
  final List<Pelicula> movies;

  const _MovieGroupSection({required this.title, required this.movies});

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
            children: movies.map((pelicula) {
              return ContentCard(
                title: pelicula.titleEN,
                imageUrl: pelicula.poster,
                heroTag: "${title}_${pelicula.id}",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailsScreen(pelicula: pelicula),
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
