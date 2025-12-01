import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:vibe_ai/pages/video.dart';
import 'dart:math';



class VideoItem {
  final String title;
  final String duration;
  final String thumbnailUrl;

  VideoItem({
    required this.title,
    required this.duration,
    required this.thumbnailUrl,
  });
}

class VideoPage extends StatefulWidget {
  const VideoPage({super.key, required String thumbnailUrl, required String title, required String videoUrl});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final List<String> categories = ["All Videos", "Downloaded", "Favorites"];
  final Map<String, List<VideoItem>> videoLists = {};

  final List<String> randomVideoNames = [
    "Chill Beats", "Summer Vibes", "Deep Focus", "Night Drive",
    "Workout Mix", "Relaxing Piano", "Jazz Classics", "Epic Moments"
  ];

  int selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    final rand = Random();

    for (String cat in categories) {
      videoLists[cat] = List.generate(
        6,
        (i) => VideoItem(
          title: randomVideoNames[rand.nextInt(randomVideoNames.length)],
          duration:
              "${rand.nextInt(4) + 1}:${rand.nextInt(60).toString().padLeft(2, '0')}",
          thumbnailUrl:
              "https://picsum.photos/seed/${rand.nextInt(9999)}/600/400",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<VideoItem> videos =
        videoLists[categories[selectedCategory]] ?? [];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF000000),
              Color(0xFF0A1A44),
              Color(0xFF2E005C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.15, 0.55, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _circleIcon(Iconsax.video),
                    const Text(
                      "Videos",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _circleIcon(Iconsax.search_normal),
                  ],
                ),
              ),

              // Category tabs
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, idx) {
                    final active = selectedCategory == idx;
                    return GestureDetector(
                      onTap: () => setState(() => selectedCategory = idx),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(active ? 0.20 : 0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          categories[idx],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                active ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Video list
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: videos.length,
                  itemBuilder: (context, i) {
                    final video = videos[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoViewerPage(
                              title: video.title,
                              thumbnailUrl: video.thumbnailUrl,
                              videoUrl:
                                  "https://samplelib.com/lib/preview/mp4/sample-5s.mp4", thumbnail: '', url: '',
                            ),
                          ),
                        );
                      },
                      child: _VideoCard(video: video),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final VideoItem video;

  const _VideoCard({required this.video});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 140,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: Colors.white.withOpacity(0.2), width: 0.8),
            ),
            child: Row(
              children: [
                // Thumbnail
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(video.thumbnailUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Text
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          video.duration,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
