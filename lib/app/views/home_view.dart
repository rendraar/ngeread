import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan/app/controllers/navigator_controller.dart';
import 'package:latihan/app/models/book.dart';
import 'package:latihan/app/models/custom_bottom_navbar.dart';
import 'package:latihan/app/views/library_view.dart';
import 'package:latihan/app/views/profile_view.dart';

class HomeView extends StatelessWidget {
  final NavigationController navigationController = Get.put(NavigationController());

  final List<Book> currentlyReading = [
    Book(title: 'Wish', author: 'Barbara O\'connor', imageUrl: 'assets/books/atomic_habits.jpg'),
    // ... other books
  ];

  final List<Book> recentlyAdded = [
    Book(title: 'Koala', author: 'Rachel Jim', imageUrl: 'path/to/koala_cover.jpg'),
    // ... other books
  ];

  final List<Book> mostRead = [
    Book(title: 'Lion King: I am Simba', author: 'Barbara O\'connor', imageUrl: 'path/to/lion_king_cover.jpg'),
    // ... other books
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: navigationController.selectedIndex.value,
        children: [
          HomeContent(context),
          LibraryView(),
          ProfileView(),
        ],
      )),
    );
  }

  Widget HomeContent(BuildContext context) {
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
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            // Currently Reading section
            _buildBookList('Currently Reading', currentlyReading),

            // Recently Added section
            _buildBookList('Recently Added', recentlyAdded),

            // Most Read section
            _buildBookList('Most Read', mostRead),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
Widget _buildBookList(String title, List<Book> books) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,

            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: books.length,
        itemBuilder: (context, index) {
          Book book = books[index];
          return ListTile(
            leading: Container(
              width: 100,
              height: 120,
              child: Image.network(book.imageUrl, fit: BoxFit.cover),
            ),
            title: Text(book.title),
            subtitle: Text(book.author),
          );
        },
      ),
    ],
  );
}