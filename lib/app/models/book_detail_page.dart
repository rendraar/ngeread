import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'read_book_page.dart'; // Import halaman untuk membaca buku

class BookDetailPage extends StatelessWidget {
  final Map<String, String> book;

  const BookDetailPage({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book["title"]!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar buku di tengah
            Center(
              child: Container(
                height: 200,
                width: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(book["image"]!),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Judul buku
            Text(
              book["title"]!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Penulis buku
            Text(
              "Author: ${book["author"]}",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            // Deskripsi buku
            Text(
              "This is a placeholder description for the book. You can replace this with a dynamic synopsis or a summary of the book's content.",
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            Spacer(),
            // Tombol Read Book
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman ReadBookPage dengan isi buku
                  Get.to(() => ReadBookPage(
                    bookTitle: book["title"]!,
                    bookContent: '''
Once upon a time in a small village, there lived a little girl named Clara. Clara loved to explore the woods near her house, where she often found fascinating treasures like colorful stones and peculiar-looking leaves. One day, as she ventured deeper into the forest, she stumbled upon an old, mysterious book lying beneath a giant oak tree. The book had golden edges and its cover was engraved with strange symbols.

Curious, Clara took the book home and opened it. To her surprise, the book wasn't just an ordinary one—it was a magical book that told stories about her adventures before they even happened! The book would glow whenever she turned a page, and its words would rearrange themselves to reveal new tales.

Clara quickly realized that the book wasn't just a storyteller—it also gave her hints and guidance for her adventures. One day, the book told her about a hidden treasure buried beneath the oak tree where she found it. With the help of the book, Clara embarked on an exciting journey to uncover the treasure. Along the way, she met new friends, solved puzzles, and overcame challenges.

Through her adventures, Clara learned the value of bravery, friendship, and curiosity. The magical book became her trusted companion, and together, they created countless unforgettable memories.
                        ''',
                  ));
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Read Book",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
