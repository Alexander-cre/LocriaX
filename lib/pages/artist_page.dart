import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../pages/theme_controller.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({super.key});

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  final audioQuery = OnAudioQuery();
  List<ArtistModel> artists = [];

  @override
  void initState() {
    super.initState();
    loadArtists();
  }

  void loadArtists() async {
    final allArtists = await audioQuery.queryArtists();
    setState(() {
      artists = allArtists;
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
              "Artists",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: text,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: artists.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: artists.length,
                    separatorBuilder: (_, __) => Divider(color: text.withOpacity(0.1)),
                    itemBuilder: (_, i) {
                      final artist = artists[i];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: QueryArtworkWidget(
                            id: artist.id,
                            type: ArtworkType.ARTIST,
                            nullArtworkWidget: Icon(Icons.person, color: text, size: 32),
                          ),
                        ),
                        title: Text(
                          artist.artist,
                          style: TextStyle(color: text, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          "${artist.numberOfAlbums} albums",
                          style: TextStyle(color: subText, fontSize: 13),
                        ),
                        onTap: () {
                          // TODO: Navigate to artist songs page
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
