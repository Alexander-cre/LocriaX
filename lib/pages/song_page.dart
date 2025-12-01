import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:iconsax/iconsax.dart';

class SongPage extends StatefulWidget {
  final String title;
  final String artist;
  final String thumbnail;
  final String audioUrl;

  const SongPage({
    super.key,
    required this.title,
    required this.artist,
    required this.thumbnail,
    required this.audioUrl, required String albumArt, required String imageUrl, required String url,
  });

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  Duration total = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    player.onDurationChanged.listen((d) => setState(() => total = d));
    player.onPositionChanged.listen((p) => setState(() => position = p));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Full background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF09090F), Color(0xFF16161E)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // ALBUM ART
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      widget.thumbnail,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Title + Artist
                  Text(widget.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),

                  const SizedBox(height: 6),

                  Text(
                    widget.artist,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 16),
                  ),

                  const Spacer(),

                  // GLASS CONTROL AREA
                  _playerControls(context),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _playerControls(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
            ),
          ),
          child: Column(
            children: [
              // SLIDER
              Slider(
                value: position.inSeconds.toDouble(),
                max: total.inSeconds.toDouble(),
                onChanged: (value) {
                  player.seek(Duration(seconds: value.toInt()));
                },
                activeColor: Colors.white,
                inactiveColor: Colors.white24,
              ),

              const SizedBox(height: 12),

              // PLAY CONTROLS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Iconsax.previous, size: 34, color: Colors.white70),

                  GestureDetector(
                    onTap: () async {
                      if (isPlaying) {
                        await player.pause();
                      } else {
                        await player.play(UrlSource(widget.audioUrl));
                      }
                      setState(() => isPlaying = !isPlaying);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  Icon(Iconsax.next, size: 34, color: Colors.white70),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
