import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan/app/controllers/auth_controller.dart';
import 'package:latihan/app/controllers/profile_controller.dart'; // Import ProfileController
import 'package:latihan/app/views/auth/signin_view.dart';
import 'package:latihan/app/models/custom_bottom_navbar.dart';

class ProfileView extends StatelessWidget {
  final AuthController _auth = Get.find();
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final user = _auth.firebaseUser.value;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.off(() => SigninView());
      });
    }

    // Set email ke ProfileController
    profileController.setUserEmail(user?.email ?? "");

    String displayName = user?.email?.split('@')[0] ?? "User";
    String email = user?.email ?? "No Email";

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.cyan.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10,),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  PopupMenuButton(
                    icon: Icon(Icons.more_horiz, color: Colors.black, size: 30),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        child: Text("Edit Photo Profile"),
                        value: 'edit',
                      ),
                      PopupMenuItem(
                        child: Text("Delete Photo Profile"),
                        value: 'delete',
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        profileController.editProfileImage();
                      } else if (value == 'delete') {
                        profileController.deleteProfileImage();
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
              child: Text(
                "My Profile",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: GestureDetector(
                onTap: () {
                  if (profileController.profileImage != null) {
                    _showProfileImage(context); // Hanya bisa diperbesar jika profileImage tidak null
                  }
                },
                child: GetBuilder<ProfileController>(
                  builder: (controller) {
                    return CircleAvatar(
                      radius: 80,
                      backgroundImage: controller.profileImage != null
                          ? FileImage(controller.profileImage!)
                          : AssetImage(controller.defaultImage) as ImageProvider,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Username:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          displayName,
                          style: TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis, // Untuk menangani teks panjang
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Email:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          email,
                          style: TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis, // Untuk menangani teks panjang
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  elevation: 0,
                ),
                onPressed: () async {
                  await _auth.signOut();
                },
                child: Text(
                  "Logout",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  void _showProfileImage(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.3),
            body: Stack(
              alignment: Alignment.topLeft,
              children: [
                Center(
                  child: GetBuilder<ProfileController>(
                    builder: (controller) {
                      return Image.file(
                        controller.profileImage ?? File(controller.defaultImage),
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}