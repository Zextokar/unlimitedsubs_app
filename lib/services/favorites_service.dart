
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- ¡ESTA LÍNEA FALTABA!
import 'package:shared_preferences/shared_preferences.dart';

const String _favoritesKey = 'user_favorites_list';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier().._loadFavorites();
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  SharedPreferences? _prefs;

  Future<void> _loadFavorites() async {
    _prefs = await SharedPreferences.getInstance();
    final favorites = _prefs?.getStringList(_favoritesKey);
    if (favorites != null) {
      state = favorites.toSet();
    }
  }

  Future<void> _saveFavorites() async {
    await _prefs?.setStringList(_favoritesKey, state.toList());
  }

  void addFavorite(String id) {
    if (!state.contains(id)) {
      state = {...state, id}; // Actualiza el estado (inmutable)
      _saveFavorites();
    }
  }

  void removeFavorite(String id) {
    if (state.contains(id)) {
      state = state.where((favId) => favId != id).toSet();
      _saveFavorites();
    }
  }

  void toggleFavorite(String id) {
    if (state.contains(id)) {
      removeFavorite(id);
    } else {
      addFavorite(id);
    }
  }
}
