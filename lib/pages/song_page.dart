import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongPage extends StatefulWidget {
  final SongModel song;
  final List<SongModel> songs;
  final int index;

  const SongPage({super.key, required this.song, required this.songs, required this.index});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  late AudioPlayer _player;
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    currentIndex = widget.index;
    playSong(widget.songs[currentIndex].data);
  }

  Future<void> playSong(String path) async {
    await _player.setFilePath(path);
    _player.play();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final song = widget.songs[currentIndex];

    return Scaffold(
      appBar: AppBar(title: Text(song.title)),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Artwork
            QueryArtworkWidget(
              id: song.id,
              type: ArtworkType.AUDIO,
              artworkBorder: BorderRadius.circular(20),
              nullArtworkWidget: Container(
                width: 250,
                height: 250,
                color: Colors.grey,
                child: const Icon(Icons.music_note, size: 100, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            // Slider
            StreamBuilder<Duration>(
              stream: _player.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final total = _player.duration ?? Duration(seconds: 1);

                return Column(
                  children: [
                    Slider(
                      value: position.inSeconds.toDouble().clamp(0, total.inSeconds.toDouble()),
                      max: total.inSeconds.toDouble(),
                      onChanged: (value) {
                        _player.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatDuration(position)),
                        Text(formatDuration(total)),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 30),
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, size: 36),
                  onPressed: () {
                    if (currentIndex > 0) {
                      currentIndex--;
                      playSong(widget.songs[currentIndex].data);
                      setState(() {});
                    }
                  },
                ),
                StreamBuilder<bool>(
                  stream: _player.playingStream,
                  builder: (context, snapshot) {
                    final playing = snapshot.data ?? false;
                    return IconButton(
                      icon: Icon(playing ? Icons.pause_circle : Icons.play_circle, size: 60),
                      onPressed: () {
                        if (playing) _player.pause();
                        else _player.play();
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, size: 36),
                  onPressed: () {
                    if (currentIndex < widget.songs.length - 1) {
                      currentIndex++;
                      playSong(widget.songs[currentIndex].data);
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Speed control
            StreamBuilder<double>(
              stream: _player.speedStream,
              builder: (context, snapshot) {
                final speed = snapshot.data ?? 1.0;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Speed: ${speed.toStringAsFixed(1)}x"),
                    IconButton(
                      icon: const Icon(Icons.speed),
                      onPressed: () {
                        final newSpeed = speed == 1.0 ? 1.5 : 1.0;
                        _player.setSpeed(newSpeed);
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    final min = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$min:$sec";
  }
}
