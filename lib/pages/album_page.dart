import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../pages/theme_controller.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final audioQuery = OnAudioQuery();
  List<AlbumModel> albums = [];

  @override
  void initState() {
    super.initState();
    loadAlbums();
  }

  void loadAlbums() async {
    final allAlbums = await audioQuery.queryAlbums();
    setState(() {
      albums = allAlbums;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Albums",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: text,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: albums.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: albums.length,
                    separatorBuilder: (_, __) => Divider(color: text.withOpacity(0.1)),
                    itemBuilder: (_, i) {
                      final album = albums[i];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: QueryArtworkWidget(
                            id: album.id,
                            type: ArtworkType.ALBUM,
                            nullArtworkWidget: Icon(Icons.album, color: text, size: 32),
                          ),
                        ),
                        title: Text(
                          album.album,
                          style: TextStyle(color: text, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          album.artist ?? "Unknown",
                          style: TextStyle(color: subText, fontSize: 13),
                        ),
                        onTap: () {
                          // TODO: Navigate to album songs page
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
