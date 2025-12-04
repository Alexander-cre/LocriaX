import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_ai/pages/music_library.dart';
import 'package:vibe_ai/pages/theme_controller.dart';
import 'package:vibe_ai/pages/settings_page.dart';
import 'package:iconsax/iconsax.dart';

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);

    // Remove const, since LibraryPage/SettingsPage are not const anymore
    final _pages = [
      const LibraryTabsPage(selectMode: false,),
      const SettingsPage(),
    ];

    return Scaffold(
      extendBody: true, // floating nav
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
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
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Iconsax.music),
                    label: 'Library',
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
