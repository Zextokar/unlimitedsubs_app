// lib/screens/home_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../services/api_service.dart';
import '../services/home_providers.dart';
import 'details_screen.dart';
import 'player_screen.dart';
import 'special_details_screen.dart';
import 'movie_details_screen.dart';
import 'special_one_cap_details_screen.dart';

import '../models/episodio_con_serie.dart';
import '../models/episodio_especial_con_contexto.dart';
import '../models/serie.dart';
import '../models/pelicula.dart';
import '../models/especial_one_cap.dart';
import '../models/especial_multi_cap.dart';
import '../models/video_musical.dart';
import '../models/search_result_item.dart';
import '../widgets/content_card.dart';
import '../widgets/shimmer_placeholders.dart';
import '../utils/date_parser.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

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
              'Inicio',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ],
        ),
      ),
      body: allDataAsync.when(
        loading: () => const HomeScreenSkeleton(),
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
        data: (allData) {
          final heroBannerSeries = ref.watch(heroBannerProvider);
          final myList = ref.watch(myListProvider);
          final recentlyWatched = ref.watch(recentlyWatchedProvider);
          
          // --- ¡CAMBIO AQUÍ! Ordenamiento Inteligente (Fecha + Número) ---
          final latestEpisodes = ref.watch(latestEpisodesProvider).toList()
            ..sort((a, b) {
               // 1. Comparar Fechas (Más reciente primero)
               final dateA = parseDate(a.episodio.releaseDate);
               final dateB = parseDate(b.episodio.releaseDate);
               final dateComparison = dateB.compareTo(dateA);
               
               if (dateComparison != 0) {
                 return dateComparison; 
               }
               
               // 2. Si la fecha es igual, comparar Número (Más alto primero)
               return b.episodio.episodeNumber.compareTo(a.episodio.episodeNumber);
            });

          final latestSpecials = ref.watch(latestSpecialEpisodesProvider).toList()
            ..sort((a, b) {
               // Misma lógica para especiales
               final dateA = parseDate(a.episodio.releaseDate);
               final dateB = parseDate(b.episodio.releaseDate);
               final dateComparison = dateB.compareTo(dateA);
               
               if (dateComparison != 0) {
                 return dateComparison;
               }
               return b.episodio.episodeNumber.compareTo(a.episodio.episodeNumber);
            });
          // --- FIN CAMBIO ---

          final latestD2V = ref.watch(latestDirectToVideoProvider);
          final latestMovies = ref.watch(latestMoviesProvider);
          final latestMusic = ref.watch(latestMusicProvider);
          final hbdvds = ref.watch(hbdvdProvider);
          final randomSeries = ref.watch(randomSeriesProvider);

          return RefreshIndicator(
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.grey[900],
            onRefresh: () async {
              // ignore: unused_result
              await ref.refresh(allDataProvider.future);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (heroBannerSeries.isNotEmpty)
                    _HeroBanner(series: heroBannerSeries, isNewCheck: _isNew),

                  // 1. MI LISTA
                  _HomeGridSection<SearchResultItem>(
                    title: 'Mi Lista',
                    items: myList,
                    cardBuilder: (item) {
                      String subtitle = '';
                      dynamic dateToCheck = '';
                      String title = item.title;
                      String? heroTag;

                      switch (item.type) {
                        case SearchItemType.serie:
                          final serie = item.originalObject as Serie;
                          subtitle = 'Serie';
                          dateToCheck = serie.releaseDate;
                          heroTag = serie.id;
                          break;
                        case SearchItemType.pelicula:
                          final pelicula = item.originalObject as Pelicula;
                          subtitle = 'Película';
                          dateToCheck = pelicula.releaseDate2;
                          break;
                        case SearchItemType.especialMulti:
                          final especial =
                              item.originalObject as EspecialMultiCap;
                          subtitle = 'Especial (Serie)';
                          dateToCheck = especial.releaseDate2;
                          break;
                        case SearchItemType.especialOneCap:
                          final especial =
                              item.originalObject as EspecialOneCap;
                          subtitle = 'Especial';
                          dateToCheck = especial.releaseDate2;
                          break;
                        case SearchItemType.videoMusical:
                          final video = item.originalObject as VideoMusical;
                          subtitle = 'Música';
                          dateToCheck = video.releaseDate;
                          break;
                        default:
                          subtitle = '';
                      }
                      return ContentCard(
                        title: title,
                        subtitle: subtitle,
                        imageUrl: item.imageUrl,
                        isNew: _isNew(dateToCheck),
                        heroTag: heroTag,
                        onTap: () => _navigateToItem(context, item), aspectRatio: 16/9,
                      );
                    },
                  ),

                  // 2. VISTO RECIENTEMENTE
                  _HomeGridSection<SearchResultItem>(
                    title: 'Visto Recientemente',
                    items: recentlyWatched,
                    cardBuilder: (item) {
                      String subtitle = '';
                      dynamic dateToCheck = '';
                      String title = item.title;
                      switch (item.type) {
                        case SearchItemType.episodio:
                          final data = item.originalObject as EpisodioConSerie;
                          subtitle = data.serie.titleEN;
                          dateToCheck = data.episodio.releaseDate;
                          title =
                              'EP${data.episodio.episodeNumber}: ${data.episodio.episodeTitle}';
                          break;
                        case SearchItemType.episodioEspecial:
                          final data =
                              item.originalObject
                                  as EpisodioEspecialConContexto;
                          subtitle = data.especial.titleEN;
                          dateToCheck = data.episodio.releaseDate;
                          title =
                              'EP${data.episodio.episodeNumber}: ${data.episodio.episodeTitle}';
                          break;
                        case SearchItemType.pelicula:
                          subtitle = 'Película';
                          dateToCheck =
                              (item.originalObject as Pelicula).releaseDate2;
                          break;
                        case SearchItemType.especialOneCap:
                          subtitle = 'Especial';
                          dateToCheck = (item.originalObject as EspecialOneCap)
                              .releaseDate2;
                          break;
                        case SearchItemType.videoMusical:
                          subtitle = 'Música';
                          dateToCheck =
                              (item.originalObject as VideoMusical).releaseDate;
                          break;
                        default:
                          subtitle = '';
                      }
                      return ContentCard(
                        title: title,
                        subtitle: subtitle,
                        imageUrl: item.imageUrl,
                        isNew: _isNew(dateToCheck),
                        onTap: () => _navigateToItem(context, item), aspectRatio: 16/9,
                      );
                    },
                  ),

                  // 3. ULTIMOS EPISODIOS
                  _HomeGridSection<EpisodioConSerie>(
                    title: 'Últimos episodios publicados',
                    items: latestEpisodes,
                    cardBuilder: (data) => ContentCard(
                      title:
                          'EP${data.episodio.episodeNumber}: ${data.episodio.episodeTitle}',
                      subtitle: data.serie.titleEN,
                      imageUrl:
                          data.episodio.episodePreview ?? data.serie.poster,
                      isNew: _isNew(data.episodio.releaseDate),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayerScreen(
                              videoUrl: data.episodio.episodeURL!,
                              videoTitle: data.episodio.episodeTitle,
                              videoHash: data.episodio.episodeHash,
                              itemId: data.episodio.episodeID,
                            ),
                          ),
                        );
                      }, aspectRatio: 16/9,
                    ),
                  ),

                  // 4. RECOMENDACIONES
                  _HomeGridSection<Serie>(
                    title: 'Recomendaciones',
                    items: randomSeries,
                    cardBuilder: (data) => ContentCard(
                      title: data.titleEN,
                      subtitle: data.status,
                      imageUrl: data.poster,
                      isNew: _isNew(data.releaseDate),
                      heroTag: data.id,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(serie: data),
                          ),
                        );
                      }, aspectRatio: 16/9,
                    ),
                  ),

                  // 5. ESPECIALES (SERIES)
                  _HomeGridSection<EpisodioEspecialConContexto>(
                    title: 'Capítulos recientes de especiales',
                    items: latestSpecials,
                    cardBuilder: (data) => ContentCard(
                      title:
                          'EP${data.episodio.episodeNumber}: ${data.episodio.episodeTitle}',
                      subtitle: data.especial.titleEN,
                      imageUrl:
                          data.episodio.episodePreview ?? data.especial.poster,
                      isNew: _isNew(data.episodio.releaseDate),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayerScreen(
                              videoUrl: data.episodio.movieURL!,
                              videoTitle: data.episodio.episodeTitle,
                              videoHash: data.episodio.movieHash,
                              itemId: data.episodio.episodeSpecialID,
                            ),
                          ),
                        );
                      }, aspectRatio: 16/9,
                    ),
                  ),

                  // 6. PRODUCCIONES D2V (ESPECIALES UNITARIOS)
                  _HomeGridSection<EspecialOneCap>(
                    title: 'Producciones Directo a Video',
                    items: latestD2V,
                    cardBuilder: (data) => ContentCard(
                      title: data.titleEN,
                      subtitle: data.releaseDate,
                      imageUrl: data.poster,
                      isNew: _isNew(data.releaseDate2),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SpecialOneCapDetailsScreen(especial: data),
                          ),
                        );
                      }, aspectRatio: 16/9,
                    ),
                  ),

                  // 7. PELÍCULAS
                  _HomeGridSection<Pelicula>(
                    title: 'Nuevas películas para ver',
                    items: latestMovies,
                    cardBuilder: (data) => ContentCard(
                      title: data.titleEN,
                      subtitle: data.releaseDate.toString(),
                      imageUrl: data.poster,
                      isNew: _isNew(data.releaseDate2),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailsScreen(pelicula: data),
                          ),
                        );
                      }, aspectRatio: 16/9,
                    ),
                  ),

                  // 8. MÚSICA
                  _HomeGridSection<VideoMusical>(
                    title: 'Nuevos videos musicales',
                    items: latestMusic,
                    cardBuilder: (data) => ContentCard(
                      title: data.title,
                      subtitle: data.releaseDate,
                      imageUrl: data.coverImage,
                      isNew: _isNew(data.releaseDate),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayerScreen(
                              videoUrl: data.urlVideo,
                              videoTitle: data.title,
                              videoHash: data.urlHash,
                              itemId: data.id,
                            ),
                          ),
                        );
                      }, aspectRatio: 16/9,
                    ),
                  ),

                  // 9. HBDVD (ESPECIALES UNITARIOS)
                  _HomeGridSection<EspecialOneCap>(
                    title: 'Hyper Battle DVD',
                    items: hbdvds,
                    cardBuilder: (data) => ContentCard(
                      title: data.titleEN,
                      subtitle: data.releaseDate,
                      imageUrl: data.poster,
                      isNew: _isNew(data.releaseDate2),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SpecialOneCapDetailsScreen(especial: data),
                          ),
                        );
                      }, aspectRatio: 16/9,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToItem(BuildContext context, SearchResultItem item) {
    switch (item.type) {
      case SearchItemType.serie:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailsScreen(serie: item.originalObject as Serie),
          ),
        );
        break;

      case SearchItemType.pelicula:
        final pelicula = item.originalObject as Pelicula;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(pelicula: pelicula),
          ),
        );
        break;

      case SearchItemType.especialOneCap:
        final especial = item.originalObject as EspecialOneCap;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SpecialOneCapDetailsScreen(especial: especial),
          ),
        );
        break;

      case SearchItemType.videoMusical:
        final video = item.originalObject as VideoMusical;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerScreen(
              videoUrl: video.urlVideo,
              videoTitle: video.title,
              videoHash: item.hash,
              itemId: video.id,
            ),
          ),
        );
        break;

      case SearchItemType.especialMulti:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpecialDetailsScreen(
              especial: item.originalObject as EspecialMultiCap,
            ),
          ),
        );
        break;

      case SearchItemType.episodio:
        final data = item.originalObject as EpisodioConSerie;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerScreen(
              videoUrl: data.episodio.episodeURL!,
              videoTitle: data.episodio.episodeTitle,
              videoHash: data.episodio.episodeHash,
              itemId: data.episodio.episodeID,
            ),
          ),
        );
        break;

      case SearchItemType.episodioEspecial:
        final data = item.originalObject as EpisodioEspecialConContexto;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerScreen(
              videoUrl: data.episodio.movieURL!,
              videoTitle: data.episodio.episodeTitle,
              videoHash: data.episodio.movieHash,
              itemId: data.episodio.episodeSpecialID,
            ),
          ),
        );
        break;

      case SearchItemType.all:
        break;
    }
  }
}

// ... (Resto de widgets auxiliares igual) ...

class _HeroBanner extends ConsumerStatefulWidget {
  final List<Serie> series;
  final bool Function(dynamic) isNewCheck;

  const _HeroBanner({required this.series, required this.isNewCheck});

  @override
  ConsumerState<_HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends ConsumerState<_HeroBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % widget.series.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      margin: const EdgeInsets.only(bottom: 8),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.series.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final serie = widget.series[index];
              return _HeroBannerCard(
                serie: serie,
                isNew: widget.isNewCheck(serie.releaseDate),
              );
            },
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.series.length,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 12,
                    activeDotColor: Theme.of(context).colorScheme.primary,
                    // ignore: deprecated_member_use
                    dotColor: Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBannerCard extends StatelessWidget {
  final Serie serie;
  final bool isNew;

  const _HeroBannerCard({required this.serie, required this.isNew});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsScreen(serie: serie)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: serie.id,
                child: CachedNetworkImage(
                  imageUrl: serie.poster,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[900]),
                  errorWidget: (context, url, err) => Container(
                    color: Colors.grey[900],
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    // ignore: deprecated_member_use
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    // ignore: deprecated_member_use
                    colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isNew)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(
                                context,
                              // ignore: deprecated_member_use
                              ).colorScheme.primary.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              // ignore: deprecated_member_use
                              ).colorScheme.primary.withOpacity(0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Text(
                          'NUEVO',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    Text(
                      serie.titleEN,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 8.0, color: Colors.black)],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              // ignore: deprecated_member_use
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            serie.status.isNotEmpty
                                ? serie.status
                                : serie.releaseDate.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            // ignore: deprecated_member_use
                            ).colorScheme.primary.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeGridSection<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(T item) cardBuilder;

  const _HomeGridSection({
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