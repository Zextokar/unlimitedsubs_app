// lib/widgets/home_grid_section.dart

import 'package:flutter/material.dart';

class HomeGridSection<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(T item) cardBuilder;

  const HomeGridSection({
    super.key,
    required this.title,
    required this.items,
    required this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final itemsToShow = items.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 12.0),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
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
            children: itemsToShow.map((item) => cardBuilder(item)).toList(),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
