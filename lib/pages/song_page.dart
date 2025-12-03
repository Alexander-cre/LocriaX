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

class _SongPageState extends State<SongPage>
    with SingleTickerProviderStateMixin {
  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  Duration total = Duration.zero;
  Duration position = Duration.zero;

  // ROTATION ANIMATION CONTROLLER
  late AnimationController rotationController;

  @override
  void initState() {
    super.initState();

    // initialize animation controller
    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    rotationController.repeat();

    player.onDurationChanged.listen((d) => setState(() => total = d));
    player.onPositionChanged.listen((p) => setState(() => position = p));
  }

  @override
  void dispose() {
    player.dispose();
    rotationController.dispose();
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
          // BACKGROUND
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
                  const SizedBox(height: 20),

                  // ******** SPINNING DISC THUMBNAIL *********
                  RotationTransition(
                    turns: rotationController,
                    child: Container(
                      height: 260,
                      width: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 4,
                          )
                        ],
                        image: DecorationImage(
                          image: NetworkImage(widget.thumbnail),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 6),

                  Text(
                    widget.artist,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6), fontSize: 16),
                  ),

                  const Spacer(),

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
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Iconsax.previous, size: 34, color: Colors.white70),

                  GestureDetector(
                    onTap: () async {
                      if (isPlaying) {
                        await player.pause();
                        rotationController.stop();
                      } else {
                        await player.play(UrlSource(widget.audioUrl));
                        rotationController.repeat();
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
