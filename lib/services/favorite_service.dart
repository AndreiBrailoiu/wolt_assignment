import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/venue.dart';

// service for handling the favorite status of venues with shared preferences
class FavoriteService {
  // save the favorite status of a venue to shared preferences
  Future<void> saveFavorite(Venue venue) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, bool> favorites = await _getFavorites(); // get the current favorites
    favorites[venue.id] = venue.isFavorite; // update the favorite status of the given venue
    prefs.setString('favoriteStates', jsonEncode(favorites)); // save the updated favorites to shared preferences
  }

  // get the favorite status of a venue from shared preferences
  Future<Map<String, bool>> _getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteStates = prefs.getString('favoriteStates'); // get the favorite states from shared preferences
    // return the favorite states as a map or an empty map if there are no favorites
    return favoriteStates != null
        ? Map<String, bool>.from(jsonDecode(favoriteStates))
        : {};
  }

  // apply the favorite status to a list of venues
  Future<void> applyFavorites(List<Venue> venues) async {
    final favorites = await _getFavorites();
    // update the favorite status of each venue in the list
    for (var venue in venues) {
      if (favorites.containsKey(venue.id)) {
        venue.isFavorite = favorites[venue.id]!;
      }
    }
  }
}

// shared preferences stores data in a text-based format (JSON or XML for Android) on the device,
// depending on the platform, as a key-value pair.