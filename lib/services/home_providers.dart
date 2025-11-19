// lib/services/home_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart'; // Para leer allDataProvider
import '../models/serie.dart';
import '../models/pelicula.dart';
import '../models/especial_one_cap.dart';
import '../models/video_musical.dart';
import '../models/episodio_con_serie.dart';
import '../models/episodio_especial_con_contexto.dart';
import 'favorites_service.dart';
import 'history_service.dart'; // Importamos el historial
import '../models/search_result_item.dart';
import '../utils/date_parser.dart'; // <-- ¡AÑADIDO!

// --- La función _parseDate se eliminó de aquí ---


/// Provider #0: Las 3 series más nuevas para el Hero Banner
final heroBannerProvider = Provider<List<Serie>>((ref) {
  final allDataAsync = ref.watch(allDataProvider);

  return allDataAsync.when(
    data: (allData) {
      final allSeries = [
        ...allData.superSentai,
        ...allData.kamenRider,
        ...allData.ultraman,
        ...allData.garoSeries,
        ...allData.offTopic,
      ];
      // Usamos la función importada
      allSeries.sort((a, b) => parseDate(b.releaseDate).compareTo(parseDate(a.releaseDate)));
      
      return allSeries.take(3).toList();
    },
    loading: () => [],
    error: (e, s) => [],
  );
});

/// Provider #1: Últimos episodios de SERIES
final latestEpisodesProvider = Provider<List<EpisodioConSerie>>((ref) {
  final allDataAsync = ref.watch(allDataProvider);

  return allDataAsync.when(
    data: (allData) {
      final List<EpisodioConSerie> allEpisodes = [];
      final allSeries = [
        ...allData.superSentai,
        ...allData.kamenRider,
        ...allData.ultraman,
        ...allData.garoSeries,
        ...allData.offTopic,
      ];

      for (var serie in allSeries) {
        for (var episodio in serie.episodes) {
          if (episodio.episodeURL != null && episodio.episodeURL != "N/A") {
            allEpisodes.add(EpisodioConSerie(serie: serie, episodio: episodio));
          }
        }
      }

      allEpisodes.sort((a, b) => parseDate(b.episodio.releaseDate).compareTo(parseDate(a.episodio.releaseDate)));

      return allEpisodes.take(15).toList();
    },
    loading: () => [],
    error: (e, s) => [],
  );
});


/// Provider #2: Últimos episodios de ESPECIALES (MultiCap)
final latestSpecialEpisodesProvider = Provider<List<EpisodioEspecialConContexto>>((ref) {
  final allDataAsync = ref.watch(allDataProvider);

  return allDataAsync.when(
    data: (allData) {
      final List<EpisodioEspecialConContexto> allSpecialEpisodes = [];

      for (var especial in allData.specials.specialMultiCap) {
        for (var episodio in especial.episodes) {
          if (episodio.movieURL != null && episodio.movieURL != "N/A") {
            allSpecialEpisodes.add(EpisodioEspecialConContexto(especial: especial, episodio: episodio));
          }
        }
      }
      
      allSpecialEpisodes.sort((a, b) => parseDate(b.episodio.releaseDate).compareTo(parseDate(a.episodio.releaseDate)));
      return allSpecialEpisodes.take(10).toList();
    },
    loading: () => [],
    error: (e, s) => [],
  );
});


/// Provider #3: Últimas "Producciones Directo a Video" (Especiales OneCap)
final latestDirectToVideoProvider = Provider<List<EspecialOneCap>>((ref) {
  final allDataAsync = ref.watch(allDataProvider);
  return allDataAsync.when(
    data: (allData) {
      var items = List<EspecialOneCap>.from(allData.specials.specialOneCap);
      items.removeWhere((item) => item.category == "HBDVD");
      items.sort((a, b) => parseDate(b.releaseDate2).compareTo(parseDate(a.releaseDate2)));
      return items.take(10).toList();
    },
    loading: () => [],
    error: (e, s) => [],
  );
});


/// Provider #4: Nuevas Películas
final latestMoviesProvider = Provider<List<Pelicula>>((ref) {
  final allDataAsync = ref.watch(allDataProvider);
  return allDataAsync.when(
    data: (allData) {
      var allMovies = [
        ...allData.movies.movieCrossover,
        ...allData.movies.movieWinterSerie,
      ];
      allMovies.sort((a, b) => parseDate(b.releaseDate2).compareTo(parseDate(a.releaseDate2)));
      return allMovies.take(10).toList();
    },
    loading: () => [],
    error: (e, s) => [],
  );
});


/// Provider #5: Nuevos Videos Musicales
final latestMusicProvider = Provider<List<VideoMusical>>((ref) {
  final allDataAsync = ref.watch(allDataProvider);
  return allDataAsync.when(
    data: (allData) {
      var items = List<VideoMusical>.from(allData.music);
      items.sort((a, b) => parseDate(b.releaseDate).compareTo(parseDate(a.releaseDate)));
      return items.take(10).toList();
    },
    loading: () => [],
    error: (e, s) => [],
  );
});


/// Provider #6: HYPER BATTLE DVD
final hbdvdProvider = Provider<List<EspecialOneCap>>((ref) {
  final allDataAsync = ref.watch(allDataProvider);
  return allDataAsync.when(
    data: (allData) {
      var items = allData.specials.specialOneCap
          .where((item) => item.category == "HBDVD")
          .toList();
      items.sort((a, b) => parseDate(b.releaseDate2).compareTo(parseDate(a.releaseDate2)));
      return items.take(10).toList();
    },
    loading: () => [],
    error: (e, s) => [],
  );
});


/// Provider #7: Series Aleatorias
final randomSeriesProvider = Provider<List<Serie>>((ref) {
  final allDataAsync = ref.watch(allDataProvider);
  return allDataAsync.when(
    data: (allData) {
      final allSeries = [
        ...allData.superSentai,
        ...allData.kamenRider,
        ...allData.ultraman,
        ...allData.garoSeries,
        ...allData.offTopic,
      ];
      allSeries.shuffle();
      return allSeries.take(10).toList();
    },
    loading: () => [],
    error: (e, s) => [],
  );
});

/// Provider #8: "Mi Lista" (Favoritos)
final myListProvider = Provider<List<SearchResultItem>>((ref) {
  final favoriteIds = ref.watch(favoritesProvider);
  final allDataAsync = ref.watch(allDataProvider);

  return allDataAsync.when(
    data: (allData) {
      final List<SearchResultItem> myList = [];

      final allSeries = [...allData.superSentai, ...allData.kamenRider, ...allData.ultraman, ...allData.garoSeries, ...allData.offTopic];
      final allMovies = [...allData.movies.movieCrossover, ...allData.movies.movieWinterSerie];
      final allSpecialMulti = allData.specials.specialMultiCap;
      final allSpecialOneCap = allData.specials.specialOneCap;
      final allMusic = allData.music;

      for (var id in favoriteIds) {
        var serie = allSeries.where((s) => s.id == id).firstOrNull;
        if (serie != null) {
          myList.add(SearchResultItem(
            title: serie.titleEN,
            imageUrl: serie.poster,
            type: SearchItemType.serie,
            originalObject: serie,
          ));
          continue; 
        }
        var movie = allMovies.where((m) => m.id == id).firstOrNull;
        if (movie != null) {
          myList.add(SearchResultItem(
            title: movie.titleEN,
            imageUrl: movie.poster,
            type: SearchItemType.pelicula,
            originalObject: movie,
            hash: movie.movieHash, 
          ));
          continue;
        }
        var specialMulti = allSpecialMulti.where((s) => s.id == id).firstOrNull;
        if (specialMulti != null) {
          myList.add(SearchResultItem(
            title: specialMulti.titleEN,
            imageUrl: specialMulti.poster,
            type: SearchItemType.especialMulti,
            originalObject: specialMulti,
          ));
          continue;
        }
        var specialOneCap = allSpecialOneCap.where((s) => s.id == id).firstOrNull;
        if (specialOneCap != null) {
          myList.add(SearchResultItem(
            title: specialOneCap.titleEN,
            imageUrl: specialOneCap.poster,
            type: SearchItemType.especialOneCap,
            originalObject: specialOneCap,
            hash: specialOneCap.movieHash,
          ));
          continue;
        }
        var music = allMusic.where((m) => m.id == id).firstOrNull;
        if (music != null) {
          myList.add(SearchResultItem(
            title: music.title,
            imageUrl: music.coverImage,
            type: SearchItemType.videoMusical,
            originalObject: music,
            hash: music.urlHash,
          ));
          continue;
        }
      }
      
      return myList;
    },
    loading: () => [],
    error: (e, s) => [],
  );
});

/// Provider #9: "Visto Recientemente"
final recentlyWatchedProvider = Provider<List<SearchResultItem>>((ref) {
  final historyIds = ref.watch(historyProvider);
  final allDataAsync = ref.watch(allDataProvider);

  return allDataAsync.when(
    data: (allData) {
      final List<SearchResultItem> watchedItems = [];
      if (historyIds.isEmpty) return watchedItems;

      final allSeries = [...allData.superSentai, ...allData.kamenRider, ...allData.ultraman, ...allData.garoSeries, ...allData.offTopic];
      final allMovies = [...allData.movies.movieCrossover, ...allData.movies.movieWinterSerie];
      final allSpecialMulti = allData.specials.specialMultiCap;
      final allSpecialOneCap = allData.specials.specialOneCap;
      final allMusic = allData.music;

      for (var id in historyIds) {
        bool found = false;
        for (var serie in allSeries) {
          var ep = serie.episodes.where((e) => e.episodeID == id).firstOrNull;
          if (ep != null) {
            watchedItems.add(SearchResultItem(
              title: ep.episodeTitle,
              imageUrl: ep.episodePreview ?? serie.poster,
              type: SearchItemType.episodio, 
              originalObject: EpisodioConSerie(serie: serie, episodio: ep),
              hash: ep.episodeHash
            ));
            found = true;
            break;
          }
        }
        if (found) continue;
        var movie = allMovies.where((m) => m.id == id).firstOrNull;
        if (movie != null) {
          watchedItems.add(SearchResultItem(
            title: movie.titleEN,
            imageUrl: movie.poster,
            type: SearchItemType.pelicula,
            originalObject: movie,
            hash: movie.movieHash
          ));
          continue;
        }
        var specialOneCap = allSpecialOneCap.where((s) => s.id == id).firstOrNull;
        if (specialOneCap != null) {
          watchedItems.add(SearchResultItem(
            title: specialOneCap.titleEN,
            imageUrl: specialOneCap.poster,
            type: SearchItemType.especialOneCap,
            originalObject: specialOneCap,
            hash: specialOneCap.movieHash
          ));
          continue;
        }
        for (var especial in allSpecialMulti) {
          var ep = especial.episodes.where((e) => e.episodeSpecialID == id).firstOrNull;
          if (ep != null) {
            watchedItems.add(SearchResultItem(
              title: ep.episodeTitle,
              imageUrl: ep.episodePreview ?? especial.poster,
              type: SearchItemType.episodioEspecial, 
              originalObject: EpisodioEspecialConContexto(especial: especial, episodio: ep),
              hash: ep.movieHash
            ));
            found = true;
            break;
          }
        }
        if (found) continue;
        var music = allMusic.where((m) => m.id == id).firstOrNull;
        if (music != null) {
          watchedItems.add(SearchResultItem(
            title: music.title,
            imageUrl: music.coverImage,
            type: SearchItemType.videoMusical,
            originalObject: music,
            hash: music.urlHash
          ));
          continue;
        }
      }
      
      return watchedItems;
    },
    loading: () => [],
    error: (e, s) => [],
  );
});