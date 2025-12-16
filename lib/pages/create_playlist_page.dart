import 'package:flutter/material.dart';
import '../storage/playlist_storage.dart';

class CreatePlaylistPage extends StatefulWidget {
  const CreatePlaylistPage({super.key});

  @override
  State<CreatePlaylistPage> createState() => _CreatePlaylistPageState();
}

class _CreatePlaylistPageState extends State<CreatePlaylistPage> {
  final TextEditingController controller = TextEditingController();
  bool loading = false;

  void createPlaylist() async {
    final name = controller.text.trim();
    if (name.isEmpty) return;

    setState(() => loading = true);

    final playlists = await PlaylistStorage.loadPlaylists();
    playlists[name] = [];
    await PlaylistStorage.savePlaylists(playlists);

    setState(() => loading = false);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Playlist")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: "Playlist name"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: createPlaylist,
                    child: const Text("Create"),
                  ),
                ],
              ),
            ),
    );
  }
}
