import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class MediaViewModel extends ChangeNotifier {
  final Dio _dio = Dio();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _audioPath;
  List<String> _audioPaths = [];
  Duration _audioDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;

  String? get audioPath => _audioPath;
  List<String> get audioPaths => _audioPaths;
  Duration get audioDuration => _audioDuration;
  Duration get currentPosition => _currentPosition;
  bool get isPlaying => _isPlaying;

  MediaViewModel() {
    loadAudioFiles();
    _audioPlayer.onDurationChanged.listen((Duration d) {
      _audioDuration = d;
      notifyListeners();
    });
    _audioPlayer.onPositionChanged.listen((Duration p) {
      _currentPosition = p;
      notifyListeners();
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying = false;
      _currentPosition = Duration.zero;
      notifyListeners();
    });
  }

  Future<void> loadAudioFiles() async {
    Directory directory = await getApplicationDocumentsDirectory();
    _audioPaths = directory
        .listSync()
        .where((item) =>
            item is File && _isAudioFile(item.path)) // Filter for audio files
        .map((item) => item.path)
        .toList();
    notifyListeners();
  }

  bool _isAudioFile(String path) {
    const audioExtensions = [
      '.mp3',
      '.wav',
      '.ogg',
      '.aac',
      '.m4a',
      '.flac',
      '.wma'
    ];
    return audioExtensions.any((ext) => path.toLowerCase().endsWith(ext));
  }

  Future<void> deleteAudioFile(BuildContext context, String filePath) async {
    try {
      File file = File(filePath);
      if (await file.exists()) {
        await file.delete(); // Delete the file
        _audioPaths.remove(filePath); // Remove from the list
        notifyListeners();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File deleted successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File not found'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print("Error deleting audio file: $e");
    }
  }

  Future<void> downloadAudio(BuildContext context, String url, String filename,
      {required Function(double) onProgress}) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/$filename.mp3';

      // Check if the file already exists
      File file = File(filePath);
      if (await file.exists()) {
        // If file exists, show SnackBar and don't download again
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('الملف محمل بالفعل'),
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      // Proceed to download with Dio and track progress
      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (receivedBytes, totalBytes) {
          if (totalBytes != -1) {
            // Update progress as a percentage
            double progress = receivedBytes / totalBytes;
            onProgress(progress); // Callback for progress
          }
        },
      );

      // Add the downloaded file to your list and notify listeners
      _audioPaths.add(filePath);
      _audioPath = filePath;
      notifyListeners();

      // Show completion SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم تحميل الملف بنجاح"),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print("Error downloading audio: $e");
      // Hide any active SnackBars
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      // Show error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading file: $filename'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> playAudio(String path) async {
    if (path.isNotEmpty) {
      await _audioPlayer.play(DeviceFileSource(path));
      _isPlaying = true;
      notifyListeners();
    }
  }

  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _currentPosition = Duration.zero;
    notifyListeners();
  }

  Future<void> seekAudio(Duration position) async {
    await _audioPlayer.seek(position);
  }
}
