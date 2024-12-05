import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class ReadBookPage extends StatefulWidget {
  final String bookTitle;
  final String bookContent;

  const ReadBookPage({
    required this.bookTitle,
    required this.bookContent,
  });

  @override
  _ReadBookPageState createState() => _ReadBookPageState();
}

class _ReadBookPageState extends State<ReadBookPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isStopped = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  String audioUrl = "";

  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _audioPlayer.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _loadAudio() async {
    if (audioUrl.isNotEmpty) {
      await _audioPlayer.setSourceUrl(audioUrl);
      setState(() {
        isPlaying = true;
      });

      _audioPlayer.onPositionChanged.listen((position) {
        setState(() {
          currentPosition = position;
        });
      });

      _audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          totalDuration = duration;
        });
      });
    }
  }

  void togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() {
      isPlaying = !isPlaying;
      isStopped = false;
    });
  }

  void stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      isPlaying = false;
      isStopped = true;
      currentPosition = Duration.zero;
    });
  }

  void seekAudio(double value) async {
    final newPosition = Duration(seconds: value.toInt());
    await _audioPlayer.seek(newPosition);
    setState(() {
      currentPosition = newPosition;
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds % 60);
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: "Enter Audio URL",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  audioUrl = value;
                  // Otomatis memuat audio setelah URL dimasukkan
                  if (audioUrl.isNotEmpty) {
                    _loadAudio();
                  }
                });
              },
            ),
          ),
          if (audioUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause_circle : Icons.play_circle,
                      size: 20,
                    ),
                    onPressed: togglePlayPause,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.stop_circle,
                      size: 20,
                    ),
                    onPressed: stopAudio,
                  ),
                ],
              ),
            ),
          if (totalDuration != Duration.zero)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Slider(
                    value: currentPosition.inSeconds.toDouble(),
                    max: totalDuration.inSeconds.toDouble(),
                    onChanged: seekAudio,
                  ),
                  Text(
                    formatDuration(currentPosition) +
                        ' / ' +
                        formatDuration(totalDuration),
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8),
              child: Text(
                widget.bookContent,
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
