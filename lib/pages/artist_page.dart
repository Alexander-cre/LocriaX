import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_ai/pages/theme_controller.dart';

class ArtistPage extends StatelessWidget {
  final Map<String, List<Map<String, String>>> artists = {
    "Dreamwave": [
      {"title": "Floating Away", "thumb": "https://images.unsplash.com/photo-1507878866276-a947ef722fee?auto=format&fit=crop&w=400&q=80"},
      {"title": "Night Vibes", "thumb": "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=80"},
    ],
    "Chill Squad": [
      {"title": "Moonlight Drive", "thumb": "https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2?auto=format&fit=crop&w=400&q=80"},
    ],
  };

  ArtistPage({super.key});

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
            colors: isDark ? [Color(0xFF0D0D12), Color(0xFF1A1A24)] : [Colors.white, Colors.grey.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: ListView(
              children: artists.entries.map((entry) {
                final artistName = entry.key;
                final songs = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(artistName, style: TextStyle(color: text, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Column(
                      children: songs.map((song) {
                        return GestureDetector(
                          onTap: () {
                            // Navigate to song page
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        song["thumb"]!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(song["title"]!, style: TextStyle(color: text, fontSize: 16, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
