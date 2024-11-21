import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan/app/controllers/article_controller.dart';
import 'package:latihan/app/models/article_detail_page.dart';
import 'package:latihan/app/models/custom_bottom_navbar.dart';

class LibraryView extends StatelessWidget {
  final ArticleController controller = Get.put(ArticleController()); // Instansiasi controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white, // Warna pertama
              Colors.cyan.shade100, // Warna kedua
            ],
            begin: Alignment.topCenter, // Titik awal gradient
            end: Alignment.bottomCenter, // Titik akhir gradient
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              backgroundColor: Colors.transparent, // Transparan agar gradien terlihat
              elevation: 0,
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "API Best Sellers",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
