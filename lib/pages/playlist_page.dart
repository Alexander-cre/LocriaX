import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_ai/pages/theme_controller.dart';
import 'package:vibe_ai/pages/music_library.dart';
import 'package:iconsax/iconsax.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<Map<String, dynamic>> playlists = [
    {
      "title": "Chill Vibes",
      "songs": [],
      "image": "https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2?auto=format&fit=crop&w=400&q=80"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);
    final isDark = theme.isDarkMode;
    final text = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Color(0xFF0D0D12), Color(0xFF1A1A24)]
                : [Colors.white, Colors.grey.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and add icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Playlists", style: TextStyle(color: text, fontSize: 32, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Iconsax.add_circle, color: Colors.blueAccent, size: 30),
                      onPressed: () async {
                        // Open dialog to enter playlist name
                        String? playlistName = await _showPlaylistNameDialog(context);
                        if (playlistName != null && playlistName.isNotEmpty) {
                          // Navigate to MusicLibrary page to select songs
                          final selectedSongs = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LibraryTabsPage(selectMode: true),
                            ),
                          );

                          if (selectedSongs != null && selectedSongs is List<Map<String, dynamic>>) {
                            setState(() {
                              playlists.add({
                                "title": playlistName,
                                "songs": selectedSongs,
                                "image": selectedSongs.isNotEmpty ? selectedSongs.first["thumb"] : "",
                              });
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: playlists.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final playlist = playlists[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to playlist detail page or song list
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                            child: Container(
                              height: 80,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  if (playlist["image"] != "")
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        playlist["image"],
                                        width: 55,
                                        height: 55,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 55,
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(Iconsax.music, color: Colors.white),
                                    ),
                                  const SizedBox(width: 16),
                                  Text(
                                    playlist["title"],
                                    style: TextStyle(color: text, fontSize: 18, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _showPlaylistNameDialog(BuildContext context) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Playlist"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter playlist name"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text("Create")),
        ],
      ),
    );
  }
}
