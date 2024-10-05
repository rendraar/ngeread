import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/rating_widget.dart';

class BookReaderView extends StatefulWidget {
  final XFile imageFile;

  BookReaderView({required this.imageFile});

  @override
  _BookReaderViewState createState() => _BookReaderViewState();
}

class _BookReaderViewState extends State<BookReaderView> {
  final TextEditingController commentController = TextEditingController();
  final List<String> comments = []; // Daftar untuk menyimpan komentar
  double _rating = 0.0; // Menyimpan rating yang disubmit
  bool _isRatingSubmitted = false; // Status apakah rating sudah disubmit

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reading Book')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menampilkan gambar novel
            Container(
              margin: EdgeInsets.all(16),
              child: Image.file(
                File(widget.imageFile.path),
                fit: BoxFit.cover,
                height: 300, // Atur tinggi sesuai kebutuhan
              ),
            ),
            SizedBox(height: 20),
            // TextField untuk komentar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                  labelText: 'Tulis Komentar...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Tombol untuk memberikan komentar
            ElevatedButton(
              onPressed: () {
                String comment = commentController.text.trim();
                if (comment.isNotEmpty) {
                  // Tambahkan komentar ke dalam daftar
                  setState(() {
                    comments.add(comment);
                  });
                  commentController.clear(); // Hapus input setelah menekan tombol
                } else {
                  Get.snackbar("Info", "Komentar tidak boleh kosong");
                }
              },
              child: Text('Tombol Komen'),
            ),
            SizedBox(height: 10),
            // Tombol untuk memberi rating
            CustomRatingWidget(
              bookId: widget.imageFile.name,
              onRatingSubmitted: (double rating) {
                setState(() {
                  _rating = rating; // Menyimpan rating yang disubmit
                  _isRatingSubmitted = true; // Tandai rating sudah disubmit
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Deskripsi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Ini adalah ilustrasi atau deskripsi tentang novel yang dipilih.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Tampilkan daftar komentar
            _buildCommentList(),
            // Tampilkan rating yang disubmit jika ada
            if (_isRatingSubmitted) _buildRatingDisplay(),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan daftar komentar
  Widget _buildCommentList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Komentar:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            return _buildCommentItem(comments[index], index);
          },
        ),
      ],
    );
  }

  // Widget untuk setiap item komentar
  Widget _buildCommentItem(String comment, int index) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: ListTile(
        title: Text(comment),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            // Hapus komentar dari daftar
            setState(() {
              comments.removeAt(index);
            });
          },
        ),
      ),
    );
  }

  // Widget untuk menampilkan rating yang disubmit
  Widget _buildRatingDisplay() {
    return Column(
      children: [
        Text(
          'Rating yang Diberikan:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        // Tampilkan rating menggunakan RatingBarIndicator
        RatingBarIndicator(
          rating: _rating,
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: 40.0,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
