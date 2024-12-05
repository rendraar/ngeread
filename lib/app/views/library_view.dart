import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan/app/controllers/article_controller.dart';
import 'package:latihan/app/models/article_detail_page.dart';
import 'package:latihan/app/models/custom_bottom_navbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class LibraryView extends StatefulWidget {
  @override
  _LibraryViewState createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  final ArticleController controller =
      Get.put(ArticleController()); // Instansiasi controller
  final TextEditingController searchController =
      TextEditingController(); // Controller untuk search
  late stt.SpeechToText _speech; // Instance Speech-to-Text
  bool _isListening = false; // Status mendengarkan
  String _voiceInput = ''; // Hasil input suara

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      print('Microphone permission granted');
    } else {
      print('Microphone permission denied');
    }
  }

  void _startListening() async {
    // Ensure permission is granted before proceeding
    await requestMicrophonePermission();

    bool available = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );

    // Check if speech recognition is available
    if (!available) {
      print('Speech recognition is not available');
      return;
    }

    setState(() {
      _isListening = true;
    });

    // Start listening for speech input
    _speech.listen(onResult: (result) {
      setState(() {
        _voiceInput = result.recognizedWords;
        searchController.text = _voiceInput; // Sync with the search field
        searchController.selection = TextSelection.fromPosition(
          TextPosition(
              offset: searchController.text.length), // Set cursor to end
        );
      });
    });
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.cyan.shade100,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "API Best Sellers",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                    onPressed: () {
                      if (_isListening) {
                        _stopListening();
                      } else {
                        _startListening();
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search for books...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _voiceInput = value; // Sinkronisasi input teks manual
                  });
                },
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final results = controller.articles.value.results.books
                      .where((book) => book.title
                          .toLowerCase()
                          .contains(_voiceInput.toLowerCase()))
                      .toList();

                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final book = results[index];
                      return ListTile(
                        leading: Image.network(book.bookImage),
                        title: Text(book.title),
                        subtitle: Text(book.author),
                        onTap: () {
                          Get.to(BookDetailPage(book: book));
                        },
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
