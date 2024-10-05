import 'package:get/get.dart';
import '../models/rating_model.dart';

class RatingController extends GetxController {
  var ratingList = <Rating>[].obs; // List untuk menyimpan semua rating

  // CREATE: Tambahkan rating
  void addRating(String bookId, double rating) {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    Rating newRating = Rating(id: id, bookId: bookId, rating: rating);
    ratingList.add(newRating);
  }

  // READ: Mendapatkan rating untuk buku tertentu
  Rating? getRatingForBook(String bookId) {
    return ratingList.firstWhereOrNull((rating) => rating.bookId == bookId);
  }

  // UPDATE: Memperbarui rating
  void updateRating(String id, double newRating) {
    int index = ratingList.indexWhere((rating) => rating.id == id);
    if (index != -1) {
      ratingList[index].rating = newRating;
      ratingList.refresh(); // Memperbarui UI
    }
  }

  // DELETE: Menghapus rating
  void deleteRating(String id) {
    ratingList.removeWhere((rating) => rating.id == id);
  }
}
