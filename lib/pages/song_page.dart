import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'theme_controller.dart';

class SongPage extends StatefulWidget {
  final String title;
  final String artist;
  final String thumbnail;
  final String audioUrl;
  final String albumArt;
  final String imageUrl;
  final String url;

  const SongPage({
    super.key,
    required this.title,
    required this.artist,
    required this.thumbnail,
    required this.audioUrl,
    required this.albumArt,
    required this.imageUrl,
    required this.url, required String thumb, required bool isDark,
  });

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  bool isPlaying = false;
  double sliderValue = 0.3;
  int selectedTab = 0;
  
  get thumb => null;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);
    final isDark = theme.isDarkMode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ------------ BACKGROUND IMAGE BLUR ------------
          Positioned.fill(
            child: Image.network(
              widget.thumbnail,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child:
                BackdropFilter(filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30), child: Container(color: Colors.black.withOpacity(0.45))),
          ),

          // ------------ MAIN CONTENT ------------
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ------------ TOP SLIDER NAV ------------
                // const SizedBox(height: 10),
                // SizedBox(
                //   height: 45,
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     padding: const EdgeInsets.symmetric(horizontal: 18),
                //     children: [
                //       _topTab("Now Playing", 0, isDark),
                //       _topTab("Lyrics", 1, isDark),
                //       _topTab("Related", 2, isDark),
                //     ],
                //   ),
                // ),

                const SizedBox(height: 30),

                // ------------ ALBUM ART ------------
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                    child: Image.network(
                      thumb ?? '',
                      height: 55,
                      width: 55,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          width: 55,
                          height: 55,
                          child: Icon(Icons.music_note, color: Colors.white),
                        );
                      },
                    )

                ),

                const SizedBox(height: 25),

                // ------------ TITLE + ARTIST ------------
                Text(
                  widget.title,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.artist,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                // ------------ SLIDER ------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Slider(
                    value: sliderValue,
                    onChanged: (value) {
                      setState(() => sliderValue = value);
                    },
                    activeColor: isDark ? Colors.white : Colors.black,
                    inactiveColor: isDark ? Colors.white24 : Colors.black26,
                  ),
                ),

                const SizedBox(height: 10),

                // ------------ PLAYER CONTROLS ------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Iconsax.previous5,
                          size: 36,
                          color: isDark ? Colors.white : Colors.black),

                      // Play / Pause Button (Glass)
                      GestureDetector(
                        onTap: () =>
                            setState(() => isPlaying = !isPlaying),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withOpacity(0.12)
                                    : Colors.black.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white30
                                      : Colors.black26,
                                ),
                              ),
                              child: Icon(
                                isPlaying ? Iconsax.pause : Iconsax.play,
                                size: 36,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Icon(Iconsax.next5,
                          size: 36,
                          color: isDark ? Colors.white : Colors.black),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // ------------ BOTTOM SPACING ------------
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // TOP TAB WIDGET
  // -------------------------------------------------------------
  Widget _topTab(String text, int index, bool isDark) {
    bool active = selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: active
              ? (isDark ? Colors.white : Colors.black)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isDark ? Colors.white60 : Colors.black54,
            width: 1.2,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: active
                ? (isDark ? Colors.black : Colors.white)
                : (isDark ? Colors.white : Colors.black),
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
