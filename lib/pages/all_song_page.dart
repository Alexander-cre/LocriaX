import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_ai/pages/theme_controller.dart';
import 'package:iconsax/iconsax.dart';

class AllSongsPage extends StatelessWidget {
  final bool selectMode;
  final Function(Map<String, dynamic>)? onSongSelect;

  const AllSongsPage({super.key, this.selectMode = false, this.onSongSelect});

  final List<Map<String, String>> songs = const [
    {
      "title": "Night Vibes",
      "artist": "Synthwave Dreams",
      "thumb": "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4"
    },
    {
      "title": "Moonlight Drive",
      "artist": "Chill Squad",
      "thumb": "https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2"
    },
    {
      "title": "Floating Away",
      "artist": "Dreamwave",
      "thumb": "https://images.unsplash.com/photo-1507878866276-a947ef722fee"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);
    final isDark = theme.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black87;

    return ListView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return GestureDetector(
          onTap: () {
            if (selectMode && onSongSelect != null) {
              onSongSelect!(song); // For playlist selection
              Navigator.pop(context);
            } else {
              // Navigate to SongPage (implement separately)
              // Navigator.push(context, MaterialPageRoute(builder: (_) => SongPage(song: song)));
            }
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
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          song["thumb"] ?? '',
                          height: 55,
                          width: 55,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 55,
                              height: 55,
                              color: Colors.grey,
                              child: Icon(Icons.music_note, color: Colors.white),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song["title"] ?? 'Unknown',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              song["artist"] ?? 'Unknown',
                              style: TextStyle(
                                color: textColor.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Iconsax.play_circle5, color: textColor.withOpacity(0.8), size: 28),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
