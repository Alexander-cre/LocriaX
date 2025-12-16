import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../pages/theme_controller.dart';

class AllSongsPage extends StatefulWidget {
  final bool selectMode;
  final List<int> selectedSongIds;

  const AllSongsPage({
    super.key,
    this.selectMode = false,
    this.selectedSongIds = const [],
  });

  @override
  State<AllSongsPage> createState() => _AllSongsPageState();
}

class _AllSongsPageState extends State<AllSongsPage> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  List<SongModel> songs = [];
  List<int> selectedIds = [];

  bool permissionGranted = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    selectedIds = List.from(widget.selectedSongIds);
    _requestAndLoadSongs();
  }

  Future<void> _requestAndLoadSongs() async {
    bool status = await audioQuery.permissionsStatus();
    
    try {
    bool granted = await audioQuery.permissionsStatus();
    if (!granted) {
      granted = await audioQuery.permissionsRequest();
    }

    if (!granted) return;

    final allSongs = await audioQuery.querySongs();
    if (!mounted) return;

    setState(() => songs = allSongs);
  } catch (e) {
    // swallow error so app NEVER crashes
    debugPrint("Audio query error: $e");
  }

    if (!status) {
      status = await audioQuery.permissionsRequest();
    }

    if (!status) {
      // Permission denied → do not crash
      setState(() {
        permissionGranted = false;
        loading = false;
      });
      return;
    }

    final result = await audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );

    setState(() {
      permissionGranted = true;
      songs = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);
    final isDark = theme.isDarkMode;

    final text = isDark ? Colors.white : Colors.black87;
    final subText = text.withOpacity(0.6);

    // ❌ NO SCAFFOLD HERE (VERY IMPORTANT)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "All Songs",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: text,
            ),
          ),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: _buildContent(text, subText),
        ),
      ],
    );
  }

  Widget _buildContent(Color text, Color subText) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!permissionGranted) {
      return Center(
        child: Text(
          "Storage permission is required to show songs",
          style: TextStyle(color: text),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (songs.isEmpty) {
      return Center(
        child: Text(
          "No songs found",
          style: TextStyle(color: text),
        ),
      );
    }

    return ListView.separated(
      itemCount: songs.length,
      separatorBuilder: (_, __) => Divider(color: text.withOpacity(0.08)),
      itemBuilder: (_, i) {
        final song = songs[i];
        final isSelected = selectedIds.contains(song.id);

        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: QueryArtworkWidget(
              id: song.id,
              type: ArtworkType.AUDIO,
              artworkFit: BoxFit.cover,
              nullArtworkWidget: Icon(
                Icons.music_note,
                color: text,
                size: 30,
              ),
            ),
          ),

          title: Text(
            song.title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: text,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),

          subtitle: Text(
            song.artist ?? "Unknown",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: subText,
              fontSize: 12,
            ),
          ),

          trailing: widget.selectMode
              ? Checkbox(
                  value: isSelected,
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        selectedIds.add(song.id);
                      } else {
                        selectedIds.remove(song.id);
                      }
                    });
                  },
                )
              : null,
        );
      },
    );
  }
}
