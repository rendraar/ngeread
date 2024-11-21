import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  File? profileImage;
  final String defaultImage = "assets/profileDefault.jpg";

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

  void deleteProfileImage() {
    if (profileImage != null) {
      profileImage = null;
      update(); // Update UI
      Get.snackbar("Success", "Profile image deleted successfully.");
    } else {
      Get.snackbar("Error", "No custom profile image to delete.");
    }
  }
}
