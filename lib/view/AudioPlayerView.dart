import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerView extends StatefulWidget {
  final String audioPath;
  final AudioPlayer audioPlayer;
  final VoidCallback onStop; // Add onStop callback

  const AudioPlayerView({
    Key? key,
    required this.audioPath,
    required this.audioPlayer,
    required this.onStop, // Initialize the callback
  }) : super(key: key);

  @override
  _AudioPlayerViewState createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<AudioPlayerView> {
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();

    widget.audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });

    widget.audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
      });
    });

    widget.audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    widget.audioPlayer.play(DeviceFileSource(widget.audioPath));
  }

  @override
  void dispose() {
    widget.audioPlayer.dispose();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  Future<void> _setPlaybackSpeed(double speed) async {
    setState(() {
      _playbackSpeed = speed;
    });
    await widget.audioPlayer.setPlaybackRate(speed);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.blueAccent,
              inactiveTrackColor: Colors.blue[100],
              thumbColor: Colors.blueAccent,
              trackHeight: 4.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
            ),
            child: Slider(
              min: 0,
              max: _duration.inSeconds.toDouble(),
              value: _position.inSeconds.toDouble(),
              onChanged: (value) {
                final position = Duration(seconds: value.toInt());
                widget.audioPlayer.seek(position);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(_position),
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
                Text(formatTime(_duration),
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 50,
                icon: Icon(
                  _isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: Colors.blueAccent,
                ),
                onPressed: () {
                  if (_isPlaying) {
                    widget.audioPlayer.pause();
                  } else {
                    widget.audioPlayer.resume();
                  }
                },
              ),
              // const SizedBox(width: 20),
              // IconButton(
              //   iconSize: 50,
              //   icon: const Icon(Icons.stop_circle_outlined,
              //       color: Colors.redAccent),
              //   onPressed: () {
              //     widget.audioPlayer.stop();
              //     widget.onStop(); // Trigger the callback when stopped
              //   },
              // ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 30,
                  icon: const Icon(Icons.remove_circle_outline,
                      color: Colors.blueAccent),
                  onPressed: () {
                    if (_playbackSpeed > 0.5) {
                      _setPlaybackSpeed(_playbackSpeed - 0.25);
                    }
                  },
                ),
                const SizedBox(width: 10),
                Text(
                  'Speed: ${_playbackSpeed.toStringAsFixed(2)}x',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 10),
                IconButton(
                  iconSize: 30,
                  icon: const Icon(Icons.add_circle_outline,
                      color: Colors.blueAccent),
                  onPressed: () {
                    if (_playbackSpeed < 2.0) {
                      _setPlaybackSpeed(_playbackSpeed + 0.25);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
