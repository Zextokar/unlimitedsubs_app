// lib/widgets/content_card.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ContentCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String imageUrl;
  final VoidCallback onTap;
  final String? heroTag;
  final bool isNew;
  final double aspectRatio;

  const ContentCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.imageUrl,
    required this.onTap,
    this.heroTag,
    this.isNew = false,
    required this.aspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sectionPadding = 16.0 * 2;
    final spacing = 12.0;
    final cardWidth = (screenWidth - sectionPadding - spacing) / 2;

    Widget imageWidget = AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.grey[800]),
          errorWidget: (context, url, error) =>
              const Center(child: Icon(Icons.movie_filter_outlined)),
        ),
      ),
    );

    // Envolvemos la imagen en un Stack para el badge de "NUEVO"
    Widget imageWithBadge = Stack(
      children: [
        imageWidget,
        if (isNew)
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary, // Azul
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'NUEVO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (heroTag != null)
              Hero(
                tag: heroTag!,
                child: imageWithBadge, // Usamos la imagen con el badge
              )
            else
              imageWithBadge, // Usamos la imagen con el badge

            const SizedBox(height: 8),

            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Añadimos el subtítulo si existe
            if (subtitle != null && subtitle!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  subtitle!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
