import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_ai/pages/all_song_page.dart';
import 'package:vibe_ai/pages/playlist_page.dart';
import 'package:vibe_ai/pages/album_page.dart';
import 'package:vibe_ai/pages/artist_page.dart';
import 'package:vibe_ai/pages/settings_page.dart';
import 'package:vibe_ai/pages/theme_controller.dart';
import 'package:iconsax/iconsax.dart';

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _selectedIndex = 0;

  // Keep PlaylistPage as a key to access its functions
  final PlaylistPage playlistPage = PlaylistPage(key: PlaylistPage.playlistKey);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);

    final _pages = [
      const AllSongsPage(),
      playlistPage,
      const AlbumPage(),
      const ArtistPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButton: _selectedIndex == 1 // Only show on Playlists tab
          ? FloatingActionButton(
              onPressed: () {
                // Call createPlaylist() inside PlaylistPage
                PlaylistPage.playlistKey.currentState?.createPlaylist();
              },
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.add, size: 28),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: theme.isDarkMode
                    ? Colors.black.withOpacity(0.5)
                    : Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                currentIndex: _selectedIndex,
                onTap: (index) => setState(() => _selectedIndex = index),
                selectedItemColor: Colors.blueAccent,
                unselectedItemColor:
                    theme.isDarkMode ? Colors.white70 : Colors.black54,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Iconsax.music),
                    label: 'Songs',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Iconsax.music_playlist),
                    label: 'Playlists',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Iconsax.cd),
                    label: 'Albums',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Iconsax.user),
                    label: 'Artists',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Iconsax.setting_2),
                    label: 'Settings',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
