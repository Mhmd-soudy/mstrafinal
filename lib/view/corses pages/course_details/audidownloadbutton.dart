import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mstra/view_models/AudioViewModel.dart'; // Adjust your imports accordingly

class AudioDownloadButton extends StatefulWidget {
  final String audioUrl;
  final String filename;

  const AudioDownloadButton({
    super.key,
    required this.audioUrl,
    required this.filename,
  });

  @override
  _AudioDownloadButtonState createState() => _AudioDownloadButtonState();
}

class _AudioDownloadButtonState extends State<AudioDownloadButton> {
  bool _isDownloading = false;
  double _progress = 0.0; // Variable to hold the download progress

  @override
  Widget build(BuildContext context) {
    final mediaViewModel = Provider.of<MediaViewModel>(context, listen: false);

    return _isDownloading
        ? Container(
            padding:
                const EdgeInsets.all(8), // Add padding around the container
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green[200],
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Column(
              children: [
                // Make the LinearProgressIndicator take the available width
                LinearProgressIndicator(value: _progress),
                const SizedBox(height: 8), // Add some spacing
                Text(
                  '${(_progress * 100).toStringAsFixed(1)}%', // Display percentage
                  style: TextStyle(
                      fontWeight: FontWeight.bold), // Bold text for clarity
                ),
              ],
            ),
          )
        : GestureDetector(
            onTap: () async {
              setState(() {
                _isDownloading = true; // Start download, show progress
                _progress = 0.0; // Reset progress
              });

              await mediaViewModel.downloadAudio(
                context,
                "https://api.mstra.online/storage/${widget.audioUrl}",
                widget.filename,
                onProgress: (progress) {
                  setState(() {
                    _progress = progress; // Update progress
                  });
                },
              );

              // After the download is complete, set the state back to not downloading
              setState(() {
                _isDownloading = false;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(16),
              margin: EdgeInsets.all(8),
              child: Center(
                child: Text("تحميل"),
              ),
            ),
          );
  }
}
