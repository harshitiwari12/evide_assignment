import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String favKey = "favorites";

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(favKey) ?? [];
  }

  static Future<void> saveFavorites(List<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(favKey, favorites);
  }
}
