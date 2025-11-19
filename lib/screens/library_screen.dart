// lib/screens/library_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'library_books_screen.dart';
import 'library_movies_screen.dart';
import 'library_music_screen.dart';
import 'library_specials_multi_screen.dart';
import 'library_specials_one_cap_screen.dart';
import '../widgets/category_card.dart';
import '../services/api_service.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allDataAsync = ref.watch(allDataProvider);

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
            const Text(
              'Biblioteca',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ],
        ),
      ),
      body: allDataAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey[600]),
              const SizedBox(height: 16),
              Text(
                'Error al cargar contenido',
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                err.toString(),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        data: (allData) {
          return RefreshIndicator(
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.grey[900],
            onRefresh: () async {
              // ignore: unused_result
              await ref.refresh(allDataProvider.future);
            },
            child: GridView.count(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
              children: [
                CategoryCard(
                  title: 'Películas',
                  icon: Icons.movie_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LibraryMoviesScreen(),
                      ),
                    );
                  },
                ),
                CategoryCard(
                  title: 'Especiales (Series)',
                  icon: Icons.personal_video_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LibrarySpecialsMultiScreen(),
                      ),
                    );
                  },
                ),
                CategoryCard(
                  title: 'Especiales (Unitarios)',
                  icon: Icons.local_activity_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LibrarySpecialsOneCapScreen(),
                      ),
                    );
                  },
                ),
                CategoryCard(
                  title: 'Música',
                  icon: Icons.music_video_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LibraryMusicScreen(),
                      ),
                    );
                  },
                ),
                CategoryCard(
                  title: 'Librería',
                  icon: Icons.book_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LibraryBooksScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
