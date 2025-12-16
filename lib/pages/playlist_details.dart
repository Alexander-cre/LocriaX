import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../pages/theme_controller.dart';
import 'playlist_page.dart';
import 'all_song_page.dart';

class PlaylistDetailsPage extends StatefulWidget {
  final Playlist playlist;

  const PlaylistDetailsPage({super.key, required this.playlist});

  @override
  State<PlaylistDetailsPage> createState() => _PlaylistDetailsPageState();
}

class _PlaylistDetailsPageState extends State<PlaylistDetailsPage> {
  final audioQuery = OnAudioQuery();
  List<SongModel> songs = [];

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  void loadSongs() async {
    final allSongs = await audioQuery.querySongs();
    setState(() {
      songs = allSongs.where((s) => widget.playlist.songIds.contains(s.id)).toList();
    });
  }

  void addSongs() async {
    final selectedSongIds = await Navigator.push<List<int>>(
      context,
      MaterialPageRoute(
        builder: (_) => AllSongsPage(
          selectMode: true,
          selectedSongIds: widget.playlist.songIds,
        ),
      ),
    );

    if (selectedSongIds != null && selectedSongIds.isNotEmpty) {
      setState(() {
        widget.playlist.songIds = selectedSongIds;
        loadSongs();
      });
    }
  }

  void removeSong(int songId) {
    setState(() {
      widget.playlist.songIds.remove(songId);
      loadSongs();
    });
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: text),
        title: Text(
          widget.playlist.name,
          style: TextStyle(color: text, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: text),
            onPressed: addSongs, // Add songs
          ),
        ],
      ),
      body: songs.isEmpty
          ? Center(child: Text("No songs yet", style: TextStyle(color: text)))
          : ListView.separated(
              itemCount: songs.length,
              separatorBuilder: (_, __) => Divider(color: text.withOpacity(0.1)),
              itemBuilder: (_, i) {
                final song = songs[i];
                return ListTile(
                  leading: QueryArtworkWidget(
                    id: song.id,
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: Icon(Icons.music_note, color: text),
                  ),
                  title: Text(song.title, style: TextStyle(color: text, fontWeight: FontWeight.w500)),
                  subtitle: Text(song.artist ?? "Unknown", style: TextStyle(color: subText)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => removeSong(song.id), // Remove song
                  ),
                  onTap: () {
                    // TODO: Play song
                  },
                );
              },
            ),
    );
  }
}
