import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan/app/controllers/navigator_controller.dart';
import 'package:latihan/app/models/custom_bottom_navbar.dart';
import 'package:latihan/app/views/library_view.dart';
import 'package:latihan/app/views/profile_view.dart';

class HomeView extends StatelessWidget {
  final NavigationController navigationController = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: navigationController.selectedIndex.value,
        children: [
          HomeContent(context),
          LibraryView(),
          ProfileView(),
        ],
      )),
    );
  }

  Widget HomeContent(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white, // Warna pertama
              Colors.cyan.shade100, // Warna kedua
            ],
            begin: Alignment.topCenter, // Titik awal gradient
            end: Alignment.bottomCenter, // Titik akhir gradient
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}