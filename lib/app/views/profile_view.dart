import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan/app/controllers/auth_controller.dart';
import 'package:latihan/app/controllers/profile_controller.dart';
import 'package:latihan/app/controllers/maps_controller.dart';
import 'package:latihan/app/views/auth/signin_view.dart';
import 'package:latihan/app/models/custom_bottom_navbar.dart';
import 'package:video_player/video_player.dart';

class ProfileView extends StatelessWidget {
  final AuthController _auth = Get.find();
  final ProfileController profileController = Get.put(ProfileController());
  final MapsController mapsController = Get.put(MapsController());

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

    // Memastikan lokasi sudah diperbarui saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mapsController.locationMessage.value ==
          "Let's trace your location!") {
        mapsController.getCurrentLocation();
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
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
              _buildPopupMenuItem('Tambahkan Lokasi', 'add_location'),
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
          child: SingleChildScrollView(
            // Ensure the entire body is scrollable
            child: Padding(
              padding:
                  const EdgeInsets.all(15), // Padding around the entire content
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
                    child: Text(
                      "My Profile",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                                    : AssetImage(controller.defaultImage)
                                        as ImageProvider,
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
                              SizedBox(height: 10),
                              Obx(() => Text(
                                    mapsController.locationMessage.value,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                    ),
                                  )),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: mapsController.openGoogleMaps,
                                child: Text("Open in Google Maps"),
                              ),
                              SizedBox(height: 50),
                              // Add video display with proper padding
                              controller.profileVideo != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: FutureBuilder<void>(
                                        future: controller.videoController
                                            ?.initialize(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3,
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  FittedBox(
                                                    fit: BoxFit.cover,
                                                    child: SizedBox(
                                                      width: controller
                                                          .videoController!
                                                          .value
                                                          .size
                                                          .width,
                                                      height: controller
                                                          .videoController!
                                                          .value
                                                          .size
                                                          .height,
                                                      child: VideoPlayer(
                                                          controller
                                                              .videoController!),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    child: IconButton(
                                                      icon: Icon(
                                                        controller
                                                                .videoController!
                                                                .value
                                                                .isPlaying
                                                            ? Icons.pause_circle
                                                            : Icons.play_circle,
                                                        size: 80,
                                                        color: Colors.white,
                                                      ),
                                                      onPressed: () {
                                                        if (controller
                                                            .videoController!
                                                            .value
                                                            .isPlaying) {
                                                          controller
                                                              .videoController!
                                                              .pause();
                                                        } else {
                                                          controller
                                                              .videoController!
                                                              .play();
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        },
                                      ),
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
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String text, String value) {
    return PopupMenuItem(
      child: Text(text),
      value: value,
    );
  }

  void _handleMenuAction(String value) async {
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
      case 'add_location':
        await mapsController.getCurrentLocation();
        break;
      case 'logout':
        _auth.signOut();
        break;
    }
  }

  void _showProfileImage(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.3),
          body: Center(
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
        );
      },
    );
  }
}
