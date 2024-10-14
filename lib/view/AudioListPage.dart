import 'package:flutter/material.dart';
import 'package:mstra/view_models/AudioViewModel.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart' as path; // Import the path package
import 'AudioPlayerView.dart';

class AudioListPage extends StatefulWidget {
  const AudioListPage({super.key});

  @override
  _AudioListPageState createState() => _AudioListPageState();
}

class _AudioListPageState extends State<AudioListPage> {
  String? _selectedAudioPath;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    final mediaViewModel = Provider.of<MediaViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملفات المحملة'),
        backgroundColor: Colors.teal, // Use a modern color
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: mediaViewModel.audioPaths.length,
              itemBuilder: (context, index) {
                final audioPath = mediaViewModel.audioPaths[index];
                final fileName = path.basename(audioPath);

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4, // Add some elevation for a modern look
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      fileName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    leading: Icon(
                      Icons.audiotrack,
                      color: Colors.teal, // Match the icon color to the theme
                    ),
                    onTap: () async {
                      if (_selectedAudioPath != audioPath) {
                        await _audioPlayer.stop();
                        setState(() {
                          _selectedAudioPath = audioPath;
                        });
                        await _audioPlayer.play(DeviceFileSource(audioPath));
                      }
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        // Show confirmation dialog before deleting the file
                        bool? confirmDelete = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(' حذف الملف'),
                            content:
                                const Text('هل انت متأكد انك تريد حذف الملف ؟'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false); // Cancel
                                },
                                child: const Text('الغاء'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(true); // Confirm delete
                                },
                                child: const Text('حذف',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );

                        // If the user confirmed, proceed with the deletion
                        if (confirmDelete == true) {
                          await mediaViewModel.deleteAudioFile(
                              context, audioPath);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          if (_selectedAudioPath != null)
            AudioPlayerView(
              audioPath: _selectedAudioPath!,
              audioPlayer: _audioPlayer,
              onStop: () {
                setState(() {
                  _selectedAudioPath = null;
                });
              },
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
