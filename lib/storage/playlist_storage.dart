import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistStorage {
  static const String key = "playlists";

  /// Save playlists to SharedPreferences
  static Future<void> savePlaylists(Map<String, List<int>> playlists) async {
    final prefs = await SharedPreferences.getInstance();
    final data = playlists.map((name, ids) => MapEntry(name, jsonEncode(ids)));
    await prefs.setString(key, jsonEncode(data));
  }

  /// Load playlists
  static Future<Map<String, List<int>>> loadPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return {};

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final playlists = <String, List<int>>{};
    decoded.forEach((name, jsonIds) {
      playlists[name] = List<int>.from(jsonDecode(jsonIds));
    });
    return playlists;
  }
}
