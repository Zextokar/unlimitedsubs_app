// lib/screens/library_movies_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../widgets/content_card.dart';
import '../widgets/shimmer_placeholders.dart';
import 'movie_details_screen.dart';

class LibraryMoviesScreen extends ConsumerWidget {
  const LibraryMoviesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allDataAsync = ref.watch(allDataProvider);

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
                    Theme.of(context).colorScheme.primary,
                    // ignore: deprecated_member_use
                    Theme.of(context).colorScheme.primary.withOpacity(0.5),
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
          // Combinamos ambas listas
          final allMovies = [
            ...allData.movies.movieCrossover,
            ...allData.movies.movieWinterSerie,
          ];

          if (allMovies.isEmpty) {
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
                    'No hay películas disponibles',
                    style: TextStyle(color: Colors.grey[500], fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contador
                Row(
                  children: [
                    Icon(
                      Icons.local_movies_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${allMovies.length} películas disponibles',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Grid
                Wrap(
                  spacing: 12.0,
                  runSpacing: 16.0,
                  children: allMovies.map((pelicula) {
                    return ContentCard(
                      title: pelicula.titleEN,
                      imageUrl: pelicula.poster,
                      heroTag: pelicula.id,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailsScreen(pelicula: pelicula),
                          ),
                        );
                      },
                      aspectRatio: 2 / 3,
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
