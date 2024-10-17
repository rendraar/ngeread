import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Tambahkan impor ini
import 'package:tes/models/book_model.dart';

class RatingView extends StatefulWidget {
  final Book book;

  RatingView({required this.book}); // Menerima buku sebagai parameter

  @override
  _RatingViewState createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  int _rating = 0; // Menyimpan rating dari 1 hingga 5

  @override
  void initState() {
    super.initState();
    _rating = widget.book.rating?.toInt() ?? 0; // Mengatur rating jika ada
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate ${widget.book.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Rate this Book',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      // Set rating hanya jika lebih dari 0
                      _rating = index + 1; // index dimulai dari 0, jadi +1
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _rating == 0
                  ? null // Nonaktifkan tombol jika rating 0
                  : () {
                // Simpan rating atau lakukan aksi lain
                setState(() {
                  widget.book.rating = _rating.toDouble(); // Set rating
                });
                print('Rating submitted for ${widget.book.title}: $_rating');
                Get.back(); // Kembali setelah submit
              },
              child: Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }
}
