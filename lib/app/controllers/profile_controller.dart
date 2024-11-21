import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  File? profileImage;
  final String defaultImage = "assets/profileDefault.jpg";

  String? userEmail; // Tambahkan email pengguna sebagai identifier

  @override
  void onInit() {
    super.onInit();
  }

  void setUserEmail(String email) {
    userEmail = email;
    _loadProfileImage(); // Load gambar berdasarkan email
  }

  Future<void> editProfileImage() async {
    Get.defaultDialog(
      title: "Update Profile Picture",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.photo),
            label: Text("Gallery"),
            onPressed: () => _pickImage(ImageSource.gallery),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.camera),
            label: Text("Camera"),
            onPressed: () => _pickImage(ImageSource.camera),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 100,
        maxWidth: 600,
        maxHeight: 600,
      );

      if (image != null && (image.path.endsWith('.png') || image.path.endsWith('.jpg') || image.path.endsWith('.jpeg'))) {
        profileImage = File(image.path);
        await _saveProfileImage(image.path); // Save to shared_preferences with email as key
        Get.back();
        update(); // Update UI
        Get.snackbar("Success", "Profile image updated successfully.");
      } else {
        Get.back();
        Get.snackbar("Error", "Only PNG, JPG, JPEG files are allowed.");
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }

  Future<void> _saveProfileImage(String imagePath) async {
    if (userEmail == null) return; // Pastikan email sudah di-set

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImage_${userEmail!}', imagePath);
  }

  Future<void> _loadProfileImage() async {
    if (userEmail == null) return; // Pastikan email sudah di-set

    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profileImage_${userEmail!}');

    if (imagePath != null && imagePath.isNotEmpty) {
      profileImage = File(imagePath);
      update();
    } else {
      profileImage = null;
      update();
    }
  }

  void deleteProfileImage() async {
    if (profileImage != null) {
      profileImage = null;
      if (userEmail != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('profileImage_${userEmail!}'); // Remove based on email
      }
      update(); // Update UI
      Get.snackbar("Success", "Profile image deleted successfully.");
    } else {
      Get.snackbar("Error", "No custom profile image to delete.");
    }
  }
}
