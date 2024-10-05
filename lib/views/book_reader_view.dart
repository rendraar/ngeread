import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BookReaderView extends StatelessWidget {
  final XFile imageFile;

  BookReaderView({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reading Book')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(File(imageFile.path)),
            SizedBox(height: 20),
            Text('Reading: ${imageFile.name}', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}