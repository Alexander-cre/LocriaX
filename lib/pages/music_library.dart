import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_ai/pages/theme_controller.dart';
import 'album_page.dart';
import 'all_song_page.dart';
import 'artist_page.dart';
import 'playlist_page.dart';

class LibraryTabsPage extends StatefulWidget {
  const LibraryTabsPage({super.key, required bool selectMode});

  @override
  State<LibraryTabsPage> createState() => _LibraryTabsPageState();
}

class _LibraryTabsPageState extends State<LibraryTabsPage> {
  int selectedTab = 0;
  final List<String> tabs = ["All", "Albums", "Artists", "Playlists"];

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);
    final isDark = theme.isDarkMode;
    final textColor = isDark ? Colors.white : Colors.black87;
    final glass = isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05);

    final _tabPages = [
      const AllSongsPage(selectMode: false),
      AlbumPage(),
      ArtistPage(),
      PlaylistPage(),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Text(
                  "Music Library",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Tabs
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
                          color: active ? (isDark ? Colors.white12 : Colors.white) : glass,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            tabs[i],
                            style: TextStyle(
                              color: active ? (isDark ? Colors.white : Colors.black) : textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Tab content
              Expanded(
                child: IndexedStack(
                  index: selectedTab,
                  children: _tabPages,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
