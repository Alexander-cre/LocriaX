import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_ai/pages/playlist_details.dart';
import '../pages/theme_controller.dart';

class Playlist {
  String name;
  List<int> songIds;

  Playlist({required this.name, required this.songIds});
}

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  // GlobalKey to call createPlaylist() from MainTabs
  static final GlobalKey<_PlaylistPageState> playlistKey =
      GlobalKey<_PlaylistPageState>();

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<Playlist> playlists = [];
  final TextEditingController _controller = TextEditingController();

  void createPlaylist() {
    final themeController = Provider.of<ThemeController>(context, listen: false);
    final isDarkMode = themeController.isDarkMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New Playlist",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  hintText: "Playlist name",
                  hintStyle: TextStyle(
                      color: isDarkMode ? Colors.white54 : Colors.black38),
                  filled: true,
                  fillColor: isDarkMode ? Colors.white12 : Colors.black12,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    final name = _controller.text.trim();
                    if (name.isNotEmpty) {
                      setState(() {
                        playlists.add(Playlist(name: name, songIds: []));
                      });
                      _controller.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Create"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDarkMode = themeController.isDarkMode;
    final bg = isDarkMode ? const Color(0xFF0D0D12) : Colors.white;
    final text = isDarkMode ? Colors.white : Colors.black87;
    final subText = text.withOpacity(0.6);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Playlists',
                style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold, color: text),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: playlists.isEmpty
                  ? Center(
                      child: Text(
                      'No playlists yet',
                      style: TextStyle(color: text, fontSize: 16),
                    ))
                  : ListView.separated(
                      itemCount: playlists.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: text.withOpacity(0.1)),
                      itemBuilder: (_, i) {
                        final playlist = playlists[i];
                        return ListTile(
                          leading: Icon(Icons.queue_music, color: text),
                          title: Text(
                            playlist.name,
                            style: TextStyle(
                                color: text, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            '${playlist.songIds.length} songs',
                            style: TextStyle(color: subText),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlaylistDetailsPage(
                                  playlist: playlist
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
