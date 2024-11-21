import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  File? profileImage;
  final String defaultImage = 'assets/sw.jpg';
  final Rxn<String> firebaseUser = Rxn<String>();

  Future<void> editProfileImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 600,
      maxHeight: 600,
    );

    if (image != null && (image.path.endsWith('.png') || image.path.endsWith('.jpg') || image.path.endsWith('.jpeg'))) {
      profileImage = File(image.path);
      Get.back();
      Get.snackbar("Success", "Profile image updated successfully.");
    } else {
      Get.snackbar("Error", "Only PNG, JPG, JPEG files are allowed.");
    }
  }

  void deleteProfileImage() {
    if (profileImage != null) {
      profileImage = null;
      Get.snackbar("Success", "Profile image deleted successfully.");
    } else {
      Get.snackbar("Error", "No custom profile image to delete.");
    }
  }
}
