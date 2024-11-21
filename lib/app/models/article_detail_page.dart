import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:latihan/app/views/web_view_page.dart';
import 'article.dart'; // Impor model

class BookDetailPage extends StatefulWidget {
  final Book book;

  BookDetailPage({required this.book});

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  String musicUrl = "https://audio.jukehost.co.uk/ad21nm8n4JANJLbsDG97JaVvCcS2YI56";
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Listener untuk durasi total
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        totalDuration = duration;
      });
    });

    // Listener untuk posisi saat ini
    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        currentPosition = position;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _playMusic() async {
    try {
      await _audioPlayer.play(UrlSource(musicUrl));
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _pauseMusic() async {
    try {
      await _audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _stopMusic() async {
    try {
      await _audioPlayer.stop();
      setState(() {
        isPlaying = false;
        currentPosition = Duration.zero;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(book.bookImage),
            SizedBox(height: 16),
            Text("Title: ${book.title}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text("Author: ${book.author}"),
            SizedBox(height: 8),
            Text("Description: ${book.description}"),
            SizedBox(height: 8),
            Text("Price: ${book.price}"),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (book.buyLinks.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage(url: book.buyLinks[0].url),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("No buy links available.")),
                  );
                }
              },
              child: Text("View More"),
            ),
          ],
        ),
      ),
    );
  }
}
