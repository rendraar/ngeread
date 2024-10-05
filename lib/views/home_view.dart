import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tes/controllers/image_controller.dart';
import 'package:tes/views/book_reader_view.dart';
import 'package:tes/views/comment_view.dart';
import 'package:tes/views/library_view.dart';
import 'package:tes/views/profile_view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ImageController imageController = Get.put(ImageController());
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    CurrentlyReadingView(),
    LibraryView(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reading Book Online"),
        actions: [
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => imageController.pickImage(),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class CurrentlyReadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ImageController imageController = Get.find<ImageController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Currently Reading'),
        _buildBookList([
          {'title': '', 'image': 'assets/images/atomic_habits.jpg'},
          {'title': '', 'image': 'assets/images/harry_poter.jpg'},
          {'title': '', 'image': 'assets/images/sherlock.jpeg'},
          {'title': '', 'image': 'assets/images/uduu.jpg'},
          {'title': '', 'image': 'assets/images/tobey.jpeg'}
        ]),
        _buildSectionTitle('Selected Images'),
        _buildImageList(imageController),
      ],
    );
  }

  Widget _buildBookList(List<Map<String, String>> bookDetails) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: bookDetails.length,
        itemBuilder: (context, index) {
          return _buildBookCover(bookDetails[index]);
        },
      ),
    );
  }

  Widget _buildBookCover(Map<String, String> bookDetail) {
    return GestureDetector(
      onTap: () {
        // Panggil BookReaderView dengan file gambar yang sesuai
        XFile selectedImage = XFile(bookDetail['image']!); // Pastikan ini XFile yang benar
        Get.to(() => BookReaderView(imageFile: selectedImage)); // Navigasi ke BookReaderView
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        width: 120,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(bookDetail['image']!),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            bookDetail['title']!,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }


  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildImageList(ImageController imageController) {
    return Obx(() => SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageController.imageFileList.length,
        itemBuilder: (context, index) {
          return _buildImageCover(imageController.imageFileList[index]);
        },
      ),
    ));
  }

  Widget _buildImageCover(XFile imageFile) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: FileImage(File(imageFile.path)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
