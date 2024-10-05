import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../controllers/rating_controller.dart';

class CustomRatingWidget extends StatefulWidget {
  final String bookId; // ID buku untuk menampilkan rating
  final Function(double) onRatingSubmitted; // Callback untuk rating yang disubmit

  CustomRatingWidget({required this.bookId, required this.onRatingSubmitted});

  @override
  _CustomRatingWidgetState createState() => _CustomRatingWidgetState();
}

class _CustomRatingWidgetState extends State<CustomRatingWidget> {
  double _rating = 0.0; // Rating yang dipilih
  bool _isRatingSubmitted = false; // Status apakah rating sudah disubmit

  @override
  Widget build(BuildContext context) {
    final RatingController ratingController = Get.put(RatingController());

    // Mendapatkan rating untuk buku ini
    var existingRating = ratingController.getRatingForBook(widget.bookId);
    if (existingRating != null) {
      _rating = existingRating.rating; // Ambil rating yang ada
      _isRatingSubmitted = true; // Tandai bahwa rating sudah disubmit
    }

    return Column(
      children: [
        // Edit rating
        RatingBar.builder(
          initialRating: _rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (newRating) {
            setState(() {
              _rating = newRating; // Update rating yang dipilih
              _isRatingSubmitted = false; // Reset status
            });
          },
        ),
        SizedBox(height: 20),

        // Tombol submit rating
        ElevatedButton(
          onPressed: () {
            // Menyimpan rating
            if (_rating > 0) {
              if (existingRating != null) {
                // UPDATE: Ubah rating yang sudah ada
                ratingController.updateRating(existingRating.id, _rating);
              } else {
                // CREATE: Tambahkan rating baru
                ratingController.addRating(widget.bookId, _rating);
              }

              // Tandai rating sudah disubmit
              setState(() {
                _isRatingSubmitted = true;
              });

              // Panggil callback untuk memberitahu bahwa rating telah disubmit
              widget.onRatingSubmitted(_rating);
            }
          },
          child: Text('Submit Rating'),
        ),
        SizedBox(height: 20),

        // Tombol hapus rating
        if (_isRatingSubmitted) ...[
          ElevatedButton(
            onPressed: () {
              if (existingRating != null) {
                ratingController.deleteRating(existingRating.id);
                setState(() {
                  _isRatingSubmitted = false; // Reset status
                  _rating = 0.0; // Reset rating
                });
              }
            },
            child: Text('Delete Rating'),
          ),
        ],
      ],
    );
  }
}
