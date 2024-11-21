import 'package:flutter/material.dart';
import 'package:latihan/app/views/web_view_page.dart';
import 'article.dart'; // Impor model

class BookDetailPage extends StatelessWidget {
  final Book book;

  BookDetailPage({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: SingleChildScrollView(  // Menambahkan SingleChildScrollView
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
                // Pastikan ada setidaknya satu link
                if (book.buyLinks.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage(url: book.buyLinks[0].url),
                    ),
                  );
                } else {
                  // Tangani kasus di mana tidak ada link
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
