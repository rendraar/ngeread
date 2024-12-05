import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan/app/controllers/auth_controller.dart';
import 'package:latihan/app/controllers/profile_controller.dart';
import 'package:latihan/app/views/auth/signin_view.dart';
import 'package:latihan/app/models/custom_bottom_navbar.dart';
import 'package:video_player/video_player.dart';

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
    } else {
      profileController.setUserEmail(user.email!);
    }

    return Scaffold(
      extendBodyBehindAppBar: true, // Untuk menghilangkan perbedaan warna
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz, color: Colors.black, size: 30),
            onSelected: (value) => _handleMenuAction(value),
            itemBuilder: (context) => [
              _buildPopupMenuItem('Edit Profile', 'edit'),
              _buildPopupMenuItem('Delete Profile', 'delete'),
              _buildPopupMenuItem('Tambahkan Video', 'add_video'),
              _buildPopupMenuItem('Hapus Video', 'delete_video'),
              _buildPopupMenuItem('Logout', 'logout'),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.cyan.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      _showProfileImage(context);
                    }
                  },
                  child: GetBuilder<ProfileController>(
                    builder: (controller) {
                      return Column(
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: controller.profileImage != null
                                ? FileImage(controller.profileImage!)
                                : AssetImage(controller.defaultImage) as ImageProvider,
                            backgroundColor: Colors.transparent,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Username: ${user?.email?.split('@').first ?? 'Unknown'}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Email: ${user?.email ?? 'Unknown'}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 50),
                          controller.profileVideo != null
                              ? FutureBuilder<void>(
                            future: controller.videoController?.initialize(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  height: MediaQuery.of(context).size.height * 0.3,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.cover,
                                        child: SizedBox(
                                          width: controller.videoController!.value.size.width,
                                          height: controller.videoController!.value.size.height,
                                          child: VideoPlayer(controller.videoController!),
                                        ),
                                      ),
                                      Positioned(
                                        child: IconButton(
                                          icon: Icon(
                                            controller.videoController!.value.isPlaying
                                                ? Icons.pause_circle
                                                : Icons.play_circle,
                                            size: 80,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            if (controller.videoController!.value.isPlaying) {
                                              controller.videoController!.pause();
                                            } else {
                                              controller.videoController!.play();
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Center(child: CircularProgressIndicator());
                              }
                            },
                          )
                              : SizedBox(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  // Fungsi Pendukung untuk PopupMenu
  PopupMenuItem<String> _buildPopupMenuItem(String text, String value) {
    return PopupMenuItem(
      child: Text(text),
      value: value,
    );
  }

  void _handleMenuAction(String value) {
    switch (value) {
      case 'edit':
        profileController.editProfileImage();
        break;
      case 'delete':
        profileController.deleteProfileImage();
        break;
      case 'add_video':
        profileController.addVideo();
        break;
      case 'delete_video':
        profileController.deleteProfileVideo();
        break;
      case 'logout':
        _auth.signOut();
        break;
    }
  }

  // Fungsi Menampilkan Gambar Profil
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
