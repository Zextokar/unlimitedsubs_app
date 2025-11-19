
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _historyKey = 'user_watch_history';
const int _historyLimit = 30;

final historyProvider = StateNotifierProvider<HistoryNotifier, List<String>>((ref) {
  return HistoryNotifier().._loadHistory();
});

class HistoryNotifier extends StateNotifier<List<String>> {
  HistoryNotifier() : super([]);

  SharedPreferences? _prefs;

  Future<void> _loadHistory() async {
    _prefs = await SharedPreferences.getInstance();
    final history = _prefs?.getStringList(_historyKey);
    if (history != null) {
      state = history;
    }
  }

  Future<void> _saveHistory() async {
    await _prefs?.setStringList(_historyKey, state);
  }

  void addItem(String id) {
    final currentHistory = [...state];

    currentHistory.remove(id);

    currentHistory.insert(0, id);

    state = currentHistory.take(_historyLimit).toList();

    _saveHistory();
  }
}
