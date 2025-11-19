// lib/screens/special_details_screen.dart
// ¡DISEÑO PREMIUM CON EFECTOS GLASSMORPHISM!

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/especial_multi_cap.dart';
import '../models/episodio_especial.dart';
import 'player_screen.dart'; 
import '../services/favorites_service.dart';
import '../utils/date_parser.dart';

class SpecialDetailsScreen extends ConsumerWidget {
  final EspecialMultiCap especial;

  const SpecialDetailsScreen({super.key, required this.especial});

  bool _isNew(dynamic dateString) {
    if (dateString == null) return false;
    try {
      final DateTime releaseDate = parseDate(dateString);
      final DateTime now = DateTime.now();
      return now.difference(releaseDate).inDays <= 7;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableEpisodes = especial.episodes.where((ep) {
      return ep.movieURL != null && ep.movieURL != "N/A";
    }).toList();

    final isFavorite = ref.watch(favoritesProvider).contains(especial.id);

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, ref, isFavorite, especial.id),
          
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                // Información en tarjetas con glassmorphism
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildGlassInfoCards(context),
                ),
                
                const SizedBox(height: 24),
                
                // Sinopsis con diseño elegante
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                          Text(
                            'Sinopsis',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              // ignore: deprecated_member_use
                              Colors.grey[900]!.withOpacity(0.6),
                              // ignore: deprecated_member_use
                              Colors.grey[900]!.withOpacity(0.3),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          especial.synopsis,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[300],
                            height: 1.6,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Título de episodios con estilo
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
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
                      Text(
                        'Episodios',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          '${availableEpisodes.length}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Lista de episodios con nuevo diseño
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList.builder(
              itemCount: availableEpisodes.length,
              itemBuilder: (context, index) {
                final EpisodioEspecial episodio = availableEpisodes[index];
                return _EpisodeTile(
                  especial: especial,
                  episodio: episodio,
                  isNew: _isNew(episodio.releaseDate),
                  index: index,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(
                          videoUrl: episodio.movieURL!,
                          videoTitle: episodio.episodeTitle,
                          videoHash: episodio.movieHash,
                          itemId: episodio.episodeSpecialID,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context, WidgetRef ref, bool isFavorite, String heroTag) {
    return SliverAppBar(
      expandedHeight: 320.0,
      pinned: true,
      backgroundColor: Colors.black,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
          border: Border.all(
            // ignore: deprecated_member_use
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
            border: Border.all(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: Icon(
              isFavorite ? Icons.bookmark : Icons.bookmark_border,
              color: isFavorite ? Theme.of(context).colorScheme.primary : Colors.white,
            ),
            iconSize: 24,
            onPressed: () {
              ref.read(favoritesProvider.notifier).toggleFavorite(especial.id);
            },
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'special_$heroTag',
              child: CachedNetworkImage(
                imageUrl: especial.poster,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.grey[900]),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[900],
                  child: const Center(child: Icon(Icons.movie_filter_outlined)),
                ),
              ),
            ),
            // Gradiente superior
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Gradiente inferior más fuerte
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    // ignore: deprecated_member_use
                    Colors.black.withOpacity(0.9),
                    Colors.black,
                  ],
                ),
              ),
            ),
            // Título en la parte inferior
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    especial.titleEN,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGlassInfoCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GlassCard(
            icon: Icons.calendar_today_rounded,
            label: 'Año',
            value: especial.releaseDate,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _GlassCard(
            icon: Icons.star_rounded,
            label: 'Rating',
            value: especial.rating.toString(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _GlassCard(
            icon: Icons.hd_rounded,
            label: 'Calidad',
            value: especial.quality,
          ),
        ),
      ],
    );
  }
}

// Tarjeta con efecto glass
class _GlassCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _GlassCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            // ignore: deprecated_member_use
            Colors.white.withOpacity(0.1),
            // ignore: deprecated_member_use
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // ignore: deprecated_member_use
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Tile de episodio mejorado
class _EpisodeTile extends StatelessWidget {
  final EspecialMultiCap especial;
  final EpisodioEspecial episodio;
  final VoidCallback onTap; 
  final bool isNew;
  final int index;

  const _EpisodeTile({
    required this.especial,
    required this.episodio, 
    required this.onTap,
    required this.isNew,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            // ignore: deprecated_member_use
            Colors.grey[900]!.withOpacity(0.5),
            // ignore: deprecated_member_use
            Colors.grey[900]!.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          // ignore: deprecated_member_use
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Número de episodio
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        // ignore: deprecated_member_use
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        // ignore: deprecated_member_use
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      // ignore: deprecated_member_use
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${episodio.episodeNumber}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Thumbnail con gradiente
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 120,
                    height: 68,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: episodio.episodePreview ?? especial.poster,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[800],
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[800],
                            child: Icon(Icons.image_not_supported_outlined, color: Colors.grey[600]),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                // ignore: deprecated_member_use
                                Colors.black.withOpacity(0.6),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.7),
                              shape: BoxShape.circle,
                              border: Border.all(
                                // ignore: deprecated_member_use
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        if (isNew)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    // ignore: deprecated_member_use
                                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Text(
                                'NUEVO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Título y fecha
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        episodio.episodeTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          height: 1.3,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(episodio.releaseDate),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 8),
                
                // Icono de flecha
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey[600],
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(dynamic dateString) {
    if (dateString == null) return 'Sin fecha';
    try {
      final DateTime date = parseDate(dateString);
      final months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 
                      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return 'Sin fecha';
    }
  }
}