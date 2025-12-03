import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vibe_ai/pages/theme_controller.dart';
import 'song_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  int selectedTab = 0;

  final List<String> tabs = ["All", "Albums", "Artists", "Playlists"];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ThemeController.isDark,
      builder: (context, bool isDark, _) {
        final bgTop = isDark ? const Color(0xFF0D0D12) : Colors.white;
        final text = isDark ? Colors.white : Colors.black87;
        final glass = isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05);

        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0D0D12), const Color(0xFF1A1A24)]
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
                    Text(
                      "Music Library",
                      style: TextStyle(
                        color: text,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔥 TOP SCROLLING TAB BAR
                    SizedBox(
                      height: 45,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: tabs.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final active = i == selectedTab;
                          return GestureDetector(
                            onTap: () => setState(() => selectedTab = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: active ? Colors.white : glass,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Text(
                                  tabs[i],
                                  style: TextStyle(
                                    color: active ? Colors.black : text,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔥 SONG LIST
                    Expanded(
                      child: ListView(
                        children: [
                          _songTile("Night Vibes", "Synthwave Dreams",
                              "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4", text, isDark),
                          _songTile("Moonlight Drive", "Chill Squad",
                              "https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2", text, isDark),
                          _songTile("Floating Away", "Dreamwave",
                              "https://images.unsplash.com/photo-1507878866276-a947ef722fee", text, isDark),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _songTile(String title, String artist, String thumb, Color text, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SongPage(
                title: title,
                artist: artist,
                thumbnail: thumb,
                audioUrl: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
                albumArt: '',
                imageUrl: '',
                url: '',
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(thumb, height: 55, width: 55, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: TextStyle(color: text, fontSize: 18, fontWeight: FontWeight.w600)),
                        Text(artist, style: TextStyle(color: text.withOpacity(0.6), fontSize: 14)),
                      ],
                    ),
                  ),

                  Icon(Iconsax.play_circle5, color: text.withOpacity(0.8), size: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
