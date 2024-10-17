import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/article_controller.dart'; // Impor controller
import 'book_detail_page.dart'; // Untuk navigasi ke halaman detail

class LibraryView extends StatelessWidget {
  final ArticleController controller = Get.put(ArticleController()); // Instansiasi controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
        backgroundColor: Colors.lightBlue.shade300,
      ),
      body: Obx(() {
        // Jika data sedang diambil, tampilkan indikator loading
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        // Jika data sudah diambil, tampilkan daftar buku
        else {
          return ListView.builder(
            itemCount: controller.articles.value.results.books.length,
            itemBuilder: (context, index) {
              final book = controller.articles.value.results.books[index];
              return ListTile(
                leading: Image.network(book.bookImage), // Gambar buku
                title: Text(book.title), // Judul buku
                subtitle: Text(book.author), // Penulis buku
                onTap: () {
                  // Navigasi ke halaman detail buku
                  Get.to(BookDetailPage(book: book));
                },
              );
            },
          );
        }
      }),
    );
  }
}
