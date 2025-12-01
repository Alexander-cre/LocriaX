import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'song_page.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D0D12), Color(0xFF1A1A24)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Music Library",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // SONG LIST
                  Expanded(
                    child: ListView(
                      children: [
                        _glassSongTile(
                          context,
                          title: "Night Vibes",
                          artist: "Synthwave Dreams",
                          thumb: "https://i.scdn.co/image/ab67616d0000b2734e37d7f3a3b0c89e0d7f4bb2",
                        ),

                        _glassSongTile(
                          context,
                          title: "Moonlight Drive",
                          artist: "Chill Squad",
                          thumb: "https://i.scdn.co/image/ab67616d0000b2736fb84d14c13c3702c4aa4f19",
                        ),

                        _glassSongTile(
                          context,
                          title: "Floating Away",
                          artist: "Dreamwave",
                          thumb: "https://i.scdn.co/image/ab67616d0000b273d7eb5d2ff1be24c321c1a97c",
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _glassSongTile(BuildContext context,
      {required String title, required String artist, required String thumb}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SongPage(
              title: title,
              artist: artist,
              thumbnail: thumb,
              audioUrl:
                  "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", albumArt: '', imageUrl: '', url: '',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      thumb,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Title & Artist
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(artist,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                            )),
                      ],
                    ),
                  ),

                  Icon(Iconsax.play_circle5,
                      color: Colors.white.withOpacity(0.8), size: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
