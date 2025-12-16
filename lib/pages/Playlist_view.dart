import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistViewPage extends StatelessWidget {
  final String name;
  final List<int> songIds;

  const PlaylistViewPage({
    super.key,
    required this.name,
    required this.songIds,
  });

  @override
  Widget build(BuildContext context) {
    final audioQuery = OnAudioQuery();

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: audioQuery.querySongs(
          sortType: SongSortType.TITLE,
          uriType: UriType.EXTERNAL,
        ),
        builder: (_, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final allSongs = snapshot.data!;
          final playlistSongs =
              allSongs.where((s) => songIds.contains(s.id)).toList();

          if (playlistSongs.isEmpty) {
            return const Center(child: Text("No songs in playlist"));
          }

          return ListView.builder(
            itemCount: playlistSongs.length,
            itemBuilder: (_, index) {
              final song = playlistSongs[index];

              return ListTile(
                leading: QueryArtworkWidget(
                  id: song.id,
                  type: ArtworkType.AUDIO,
                ),
                title: Text(song.title),
                subtitle: Text(song.artist ?? "Unknown"),
                onTap: () {
                  // TODO: add player later
                },
              );
            },
          );
        },
      ),
    );
  }
}
