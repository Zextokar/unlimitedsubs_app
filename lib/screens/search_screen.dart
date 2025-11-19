// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/all_data.dart';
import '../models/serie.dart';
import '../models/pelicula.dart';
import '../models/especial_multi_cap.dart';
import '../models/especial_one_cap.dart';
import '../models/video_musical.dart';
import '../models/search_result_item.dart';
import '../services/api_service.dart';
import '../models/episodio_con_serie.dart';
import '../models/episodio_especial_con_contexto.dart';
import '../widgets/shimmer_placeholders.dart';
import 'details_screen.dart';
import 'special_details_screen.dart';
import 'player_screen.dart';
import 'movie_details_screen.dart';
import 'special_one_cap_details_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<SearchResultItem> _resultsList = [];
  List<SearchResultItem> _allSearchableItems = [];

  SearchItemType _selectedFilter = SearchItemType.all;

  @override
  void initState() {
    super.initState();
    _loadSearchableList();
  }

  Future<void> _loadSearchableList() async {
    final allData = await ref.read(allDataProvider.future);
    _buildSearchableList(allData);
  }

  void _filterSearch() {
    final String query = _searchController.text;

    if (query.isEmpty) {
      setState(() {
        _resultsList = [];
      });
      return;
    }

    if (_allSearchableItems.isEmpty) return;

    List<SearchResultItem> filteredByText = _allSearchableItems.where((item) {
      return item.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (_selectedFilter != SearchItemType.all) {
      const specialTypes = {
        SearchItemType.especialMulti,
        SearchItemType.especialOneCap,
      };

      filteredByText = filteredByText.where((item) {
        if (_selectedFilter == SearchItemType.especialMulti) {
          return specialTypes.contains(item.type);
        }
        return item.type == _selectedFilter;
      }).toList();
    }

    setState(() {
      _resultsList = filteredByText;
    });
  }

  void _buildSearchableList(AllData allData) {
    List<SearchResultItem> allItems = [];

    final allSeries = [
      ...allData.superSentai,
      ...allData.kamenRider,
      ...allData.ultraman,
      ...allData.garoSeries,
      ...allData.offTopic,
    ];
    allItems.addAll(
      allSeries.map(
        (serie) => SearchResultItem(
          title: serie.titleEN,
          imageUrl: serie.poster,
          type: SearchItemType.serie,
          originalObject: serie,
          hash: null,
        ),
      ),
    );

    final allMovies = [
      ...allData.movies.movieCrossover,
      ...allData.movies.movieWinterSerie,
    ];
    allItems.addAll(
      allMovies.map(
        (pelicula) => SearchResultItem(
          title: pelicula.titleEN,
          imageUrl: pelicula.poster,
          type: SearchItemType.pelicula,
          originalObject: pelicula,
          hash: pelicula.movieHash,
        ),
      ),
    );

    allItems.addAll(
      allData.specials.specialMultiCap.map(
        (especial) => SearchResultItem(
          title: especial.titleEN,
          imageUrl: especial.poster,
          type: SearchItemType.especialMulti,
          originalObject: especial,
          hash: null,
        ),
      ),
    );

    allItems.addAll(
      allData.specials.specialOneCap.map(
        (especial) => SearchResultItem(
          title: especial.titleEN,
          imageUrl: especial.poster,
          type: SearchItemType.especialOneCap,
          originalObject: especial,
          hash: especial.movieHash,
        ),
      ),
    );

    allItems.addAll(
      allData.music.map(
        (video) => SearchResultItem(
          title: video.title,
          imageUrl: video.coverImage,
          type: SearchItemType.videoMusical,
          originalObject: video,
          hash: video.urlHash,
        ),
      ),
    );

    _allSearchableItems = allItems;
  }

  Widget _buildFilterChips() {
    final Map<String, SearchItemType> filters = {
      'Todo': SearchItemType.all,
      'Series': SearchItemType.serie,
      'Películas': SearchItemType.pelicula,
      'Especiales': SearchItemType.especialMulti,
      'Música': SearchItemType.videoMusical,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: filters.entries.map((entry) {
          final String label = entry.key;
          final SearchItemType type = entry.value;
          final bool isSelected = _selectedFilter == type;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  _selectedFilter = type;
                });
                _filterSearch();
              },
              backgroundColor: isSelected
                  // ignore: deprecated_member_use
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                  : Colors.grey[850],
              selectedColor: Theme.of(
                context,
              // ignore: deprecated_member_use
              ).colorScheme.primary.withOpacity(0.2),
              checkmarkColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[400],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: isSelected
                  ? BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    )
                  : BorderSide(color: Colors.grey[800]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allDataAsync = ref.watch(allDataProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Buscar en todo el catálogo...',
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          ),
          onChanged: (query) => _filterSearch(),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _filterSearch();
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.grey[900],
        onRefresh: () async {
          final allData = await ref.refresh(allDataProvider.future);
          _buildSearchableList(allData);
          _filterSearch();
        },
        child: allDataAsync.when(
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
            if (_allSearchableItems.isEmpty) {
              _buildSearchableList(allData);
            }

            return Column(
              children: [
                _buildFilterChips(),
                Container(height: 1, color: Colors.grey[900]),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: _buildResultsList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    if (_resultsList.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: _searchController.text.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 80,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Busca series, películas, especiales...',
                      style: TextStyle(color: Colors.grey[500], fontSize: 16),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 80,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No se encontraron resultados',
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'para "${_searchController.text}"',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _resultsList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final item = _resultsList[index];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[850]!),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: AspectRatio(
              aspectRatio: 16 / 9, // ← CAMBIO: De 2/3 a 16/9
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[850]),
                  errorWidget: (context, url, err) => Container(
                    color: Colors.grey[850],
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              item.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _getItemTypeLabel(item.type),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing: Icon(
              Icons.play_circle_outline_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            onTap: () {
              FocusScope.of(context).unfocus();
              _navigateToItem(item);
            },
          ),
        );
      },
    );
  }

  String _getItemTypeLabel(SearchItemType type) {
    switch (type) {
      case SearchItemType.serie:
        return 'Serie';
      case SearchItemType.pelicula:
        return 'Película';
      case SearchItemType.especialOneCap:
        return 'Especial';
      case SearchItemType.especialMulti:
        return 'Especial (Serie)';
      case SearchItemType.videoMusical:
        return 'Video Musical';
      case SearchItemType.episodio:
        return 'Episodio';
      case SearchItemType.episodioEspecial:
        return 'Episodio Especial';
      default:
        return '';
    }
  }

  void _navigateToItem(SearchResultItem item) {
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
builder: (context) => SpecialOneCapDetailsScreen(especial: especial),
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
