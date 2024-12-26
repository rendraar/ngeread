import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class ProfileController extends GetxController {
  // Dependencies
  final ImagePicker _picker = ImagePicker();

  // Profile data
  File? profileImage;
  File? profileVideo;
  VideoPlayerController? videoController;
  String? userEmail; // Email as identifier
  String? currentLocation;

  // Reactive username variable
  RxString username = ''.obs; // RxString for reactivity

  // Default image if no profile picture
  final String defaultImage = "assets/profileDefault.jpg";

  // Reactive state variables
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfile(); // Load profile when controller is initialized
  }

  // Set current user email and reload profile
  void setUserEmail(String email) {
    userEmail = email;
    _loadProfile();
    update();
  }

  // Set current location
  void setCurrentLocation(String location) {
    currentLocation = location;
    update();
  }

  // Update username and save it in SharedPreferences
  Future<void> updateUsername(String newUsername) async {
    // Hanya update dan tampilkan snackbar jika username berubah
    if (newUsername != username.value) {
      username.value = newUsername; // Reactive update

      if (userEmail != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username_${userEmail!}',
            newUsername); // Simpan username ke SharedPreferences
      }
      update(); // Mengupdate UI
      Get.snackbar("Success", "Username updated successfully.");
    }
  }

  // Load profile data from SharedPreferences
  Future<void> _loadProfile() async {
    if (userEmail == null) return;

    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profileImage_${userEmail!}');
    final videoPath = prefs.getString('profileVideo_${userEmail!}');
    final storedUsername = prefs.getString('username_${userEmail!}');

    // Load stored username if available
    username.value =
        storedUsername ?? ''; // If no username is stored, use empty string

    // Load profile image
    profileImage = imagePath != null ? File(imagePath) : null;

    // Load profile video and initialize controller
    if (videoPath != null) {
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

  // Remaining methods (editProfileImage, addVideo, deleteProfileImage, etc.) stay the same.

  // Edit profile image
  Future<void> editProfileImage() async {
    Get.defaultDialog(
      title: "Update Profile Picture",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.photo),
            label: Text("Gallery"),
            onPressed: () =>
                _pickImageOrVideo(ImageSource.gallery, isVideo: false),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.camera),
            label: Text("Camera"),
            onPressed: () =>
                _pickImageOrVideo(ImageSource.camera, isVideo: false),
          ),
        ],
      ),
    );
  }

  // Add profile video
  Future<void> addVideo() async {
    Get.defaultDialog(
      title: "Add Profile Video",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.video_library),
            label: Text("Gallery"),
            onPressed: () =>
                _pickImageOrVideo(ImageSource.gallery, isVideo: true),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.camera),
            label: Text("Camera"),
            onPressed: () =>
                _pickImageOrVideo(ImageSource.camera, isVideo: true),
          ),
        ],
      ),
    );
  }

  // Pick image or video
  Future<void> _pickImageOrVideo(ImageSource source,
      {required bool isVideo}) async {
    try {
      isLoading.value = true;

      if (isVideo) {
        final XFile? video = await _picker.pickVideo(source: source);
        if (video != null) {
          profileVideo = File(video.path);
          videoController = VideoPlayerController.file(profileVideo!)
            ..initialize().then((_) {
              update();
            });
          await _saveProfileVideo(video.path);
          Get.snackbar("Success", "Profile video updated successfully.");
        }
      } else {
        final XFile? image =
            await _picker.pickImage(source: source, imageQuality: 100);
        if (image != null) {
          profileImage = File(image.path);
          await _saveProfileImage(image.path);
          Get.snackbar("Success", "Profile image updated successfully.");
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick media: $e");
    } finally {
      isLoading.value = false;
      Get.back();
    }
  }

  // Save profile image to SharedPreferences
  Future<void> _saveProfileImage(String imagePath) async {
    if (userEmail == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImage_${userEmail!}', imagePath);
  }

  // Save profile video to SharedPreferences
  Future<void> _saveProfileVideo(String videoPath) async {
    if (userEmail == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileVideo_${userEmail!}', videoPath);
  }

  // Delete profile image
  Future<void> deleteProfileImage() async {
    if (profileImage != null) {
      profileImage = null;
      if (userEmail != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('profileImage_${userEmail!}');
      }
      update();
      Get.snackbar("Success", "Profile image deleted successfully.");
    }
  }

  // Delete profile video
  Future<void> deleteProfileVideo() async {
    if (profileVideo != null) {
      profileVideo = null;
      if (userEmail != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('profileVideo_${userEmail!}');
      }
      update();
      Get.snackbar("Success", "Profile video deleted successfully.");
    }
  }

  // Reset profile data
  Future<void> resetProfile() async {
    profileImage = null;
    profileVideo = null;
    if (userEmail != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('profileImage_${userEmail!}');
      await prefs.remove('profileVideo_${userEmail!}');
    }
    update();
    Get.snackbar("Success", "Profile reset to default.");
  }

  // Get profile image path or default
  String getProfileImage() {
    return profileImage?.path ?? defaultImage;
  }

  // Get video controller
  VideoPlayerController? getProfileVideo() {
    return videoController;
  }
}
