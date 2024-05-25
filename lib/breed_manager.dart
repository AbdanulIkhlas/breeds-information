import 'package:shared_preferences/shared_preferences.dart';

class BreedManager {
  late SharedPreferences _prefs;
  Set<int> _favoriteIndices = {};

  void setPrefs(SharedPreferences prefs) {
    _prefs = prefs;
    _loadFavoriteIndicesFromSharedPreferences();
  }

  void _loadFavoriteIndicesFromSharedPreferences() {
    final favoriteIndices = _prefs
            .getStringList('favorite_breeds')
            ?.map((index) => int.parse(index))
            .toSet() ??
        {};
    _favoriteIndices.addAll(favoriteIndices);
  }

  void _saveFavoriteIndicesToSharedPreferences() {
    _prefs.setStringList('favorite_breeds',
        _favoriteIndices.map((index) => index.toString()).toList());
  }

  Set<int> get favoriteIndices => _favoriteIndices;

  void toggleFavorite(int index) {
    if (_favoriteIndices.contains(index)) {
      _favoriteIndices.remove(index);
    } else {
      _favoriteIndices.add(index);
    }
    _saveFavoriteIndicesToSharedPreferences();
  }
}
