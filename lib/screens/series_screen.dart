// lib/screens/series_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../widgets/shimmer_placeholders.dart';
import '../widgets/category_card.dart';
import 'series_category_screen.dart';
import '../models/serie.dart';

class _CategoryItem {
  final String title;
  final IconData icon;
  final List<Serie> series;

  _CategoryItem({
    required this.title,
    required this.icon,
    required this.series,
  });
}

class SeriesScreen extends ConsumerWidget {
  const SeriesScreen({super.key});

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
              'Series',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ],
        ),
      ),
      body: allDataAsync.when(
        loading: () => const GridScreenSkeleton(),
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
          final List<_CategoryItem> categories = [
            _CategoryItem(
              title: 'Super Sentai',
              icon: Icons.shield_outlined,
              series: allData.superSentai,
            ),
            _CategoryItem(
              title: 'Kamen Rider',
              icon: Icons.motorcycle_outlined,
              series: allData.kamenRider,
            ),
            _CategoryItem(
              title: 'Ultraman',
              icon: Icons.rocket_launch_outlined,
              series: allData.ultraman,
            ),
            _CategoryItem(
              title: 'Garo',
              icon: Icons.nightlight_outlined,
              series: allData.garoSeries,
            ),
            _CategoryItem(
              title: 'Off Topic',
              icon: Icons.explore_outlined,
              series: allData.offTopic,
            ),
          ];

          return RefreshIndicator(
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: const Color.fromARGB(255, 174, 174, 174),
            onRefresh: () async {
              // ignore: unused_result
              await ref.refresh(allDataProvider.future);
            },
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  title: category.title,
                  icon: category.icon,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeriesCategoryScreen(
                          title: category.title,
                          series: category.series,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
