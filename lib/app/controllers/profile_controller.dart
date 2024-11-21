import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class ProfileController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  File? profileImage;
  File? profileVideo;
  VideoPlayerController? videoController;
  final String defaultImage = "assets/profileDefault.jpg";
  String? userEmail; // Email as identifier

  @override
  void onInit() {
    super.onInit();
    _loadProfile(); // Load profile when controller is initialized
  }

  void setUserEmail(String email) {
    userEmail = email;
    _loadProfile(); // Load profile data (image or video) based on email
  }

  // Handle profile image update (edit only image)
  Future<void> editProfileImage() async {
    Get.defaultDialog(
      title: "Update Profile Picture",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.photo),
            label: Text("Gallery (Image)"),
            onPressed: () => _pickImageOrVideo(ImageSource.gallery, isVideo: false),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.camera),
            label: Text("Camera (Image)"),
            onPressed: () => _pickImageOrVideo(ImageSource.camera, isVideo: false),
          ),
        ],
      ),
    );
  }

  // Handle video update (add video only)
  Future<void> addVideo({bool fromCamera = false}) async {
    Get.defaultDialog(
      title: "Add Profile Video",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.video_library),
            label: Text("Gallery (Video)"),
            onPressed: () => _pickImageOrVideo(ImageSource.gallery, isVideo: true),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.camera),
            label: Text("Camera (Video)"),
            onPressed: () => _pickImageOrVideo(ImageSource.camera, isVideo: true),
          ),
        ],
      ),
    );
  }

  // Pick Image or Video (gallery or camera)
  Future<void> _pickImageOrVideo(ImageSource source, {bool isVideo = false}) async {
    try {
      if (isVideo) {
        // Pick video from gallery or camera
        final XFile? video = await _picker.pickVideo(source: source);

        if (video != null && video.path.endsWith('.mp4')) {
          profileVideo = File(video.path);
          videoController = VideoPlayerController.file(profileVideo!)
            ..initialize().then((_) {
              update(); // Update UI after video is initialized
            });
          await _saveProfileVideo(video.path); // Save video to shared_preferences
          Get.back();
          Get.snackbar("Success", "Profile video updated successfully.");
        } else {
          Get.back();
          Get.snackbar("Error", "Only MP4 videos are allowed.");
        }
      } else {
        // Pick image from gallery or camera
        final XFile? media = await _picker.pickImage(
          source: source,
          imageQuality: 100,
          maxWidth: 600,
          maxHeight: 600,
        );

        if (media != null && (media.path.endsWith('.png') || media.path.endsWith('.jpg') || media.path.endsWith('.jpeg'))) {
          profileImage = File(media.path);
          await _saveProfileImage(media.path); // Save to shared_preferences
          Get.back();
          update(); // Update UI
          Get.snackbar("Success", "Profile image updated successfully.");
        } else {
          Get.back();
          Get.snackbar("Error", "Only PNG, JPG, JPEG files are allowed.");
        }
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Failed to pick media: $e");
    }
  }

  // Save Profile Image to SharedPreferences
  Future<void> _saveProfileImage(String imagePath) async {
    if (userEmail == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImage_${userEmail!}', imagePath);
  }

  // Save Profile Video to SharedPreferences
  Future<void> _saveProfileVideo(String videoPath) async {
    if (userEmail == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileVideo_${userEmail!}', videoPath);
  }

  // Load Profile Image and Video from SharedPreferences
  Future<void> _loadProfile() async {
    if (userEmail == null) return;

    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profileImage_${userEmail!}');
    final videoPath = prefs.getString('profileVideo_${userEmail!}');

    if (imagePath != null && imagePath.isNotEmpty) {
      profileImage = File(imagePath);
    } else {
      profileImage = null;
    }

    if (videoPath != null && videoPath.isNotEmpty) {
      profileVideo = File(videoPath);
      videoController = VideoPlayerController.file(profileVideo!)
        ..initialize().then((_) {
          update();
        });
    } else {
      profileVideo = null;
    }

    update();
  }

  // Delete Profile Image
  void deleteProfileImage() async {
    if (profileImage != null) {
      profileImage = null;
      if (userEmail != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('profileImage_${userEmail!}'); // Remove image from shared_preferences
      }
      update(); // Update UI
      Get.snackbar("Success", "Profile image deleted successfully.");
    } else {
      Get.snackbar("Error", "No custom profile image to delete.");
    }
  }

  // Delete Profile Video
  void deleteProfileVideo() async {
    if (profileVideo != null) {
      profileVideo = null;
      if (userEmail != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('profileVideo_${userEmail!}'); // Remove video from shared_preferences
      }
      update(); // Update UI
      Get.snackbar("Success", "Profile video deleted successfully.");
    } else {
      Get.snackbar("Error", "No custom profile video to delete.");
    }
  }
}
