import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tes/models/book_model.dart';

class BookController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Menyimpan daftar buku
  var books = <Book>[].obs;

  // Mengambil daftar buku dari Firestore
  Future<void> fetchBooks() async {
    final snapshot = await _firestore.collection('books').get();
    books.assignAll(snapshot.docs.map((doc) {
      // Periksa jika semua field ada sebelum membuat objek Book
      if (!doc.data().containsKey('title') ||
          !doc.data().containsKey('author') ||
          !doc.data().containsKey('rating')) {
        throw Exception('Missing book data in Firestore');
      }

      return Book(
        id: doc.id,
        title: doc['title'],
        author: doc['author'],
        rating: doc['rating']?.toDouble() ?? 0.0, image: '',
      );
    }).toList());
  }

  // Fungsi untuk memberi rating pada buku
  Future<void> rateBook(String bookId, double rating) async {
    try {
      await _firestore.collection('books').doc(bookId).update({'rating': rating});
      Get.snackbar("Success", "Rating updated successfully");
      await fetchBooks(); // Refresh daftar buku
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
