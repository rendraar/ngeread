import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan/app/controllers/navigator_controller.dart';
import 'package:latihan/app/views/home_view.dart';
import 'package:latihan/app/views/library_view.dart';
import 'package:latihan/app/views/profile_view.dart';

class CustomBottomNavBar extends StatelessWidget {
  final NavigationController navigationController = Get.find();
  final bool isEnabled;

  CustomBottomNavBar({this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isSignInOrSignUp = navigationController.isSignInPage.value ||
          navigationController.isSignUpPage.value;

      return Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan, Colors.blue.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: isSignInOrSignUp
                    ? Colors.white.withOpacity(0.3)
                    : (navigationController.selectedIndex.value == 0
                        ? Colors.white
                        : Colors.white.withOpacity(0.6)),
              ),
              iconSize: 35,
              onPressed: isSignInOrSignUp
                  ? null
                  : () {
                      navigationController.changePage(0);
                      Get.off(
                        () => HomeView(), // Widget untuk halaman Home
                        transition: Transition
                            .noTransition, // Nonaktifkan animasi transisi
                      );
                    },
            ),
            IconButton(
              icon: Icon(
                Icons.book_rounded,
                color: isSignInOrSignUp
                    ? Colors.white.withOpacity(0.3)
                    : (navigationController.selectedIndex.value == 1
                        ? Colors.white
                        : Colors.white.withOpacity(0.6)),
              ),
              iconSize: 35,
              onPressed: isSignInOrSignUp
                  ? null
                  : () {
                      navigationController.changePage(1);
                      Get.off(
                        () => LibraryView(), // Widget untuk halaman Library
                        transition: Transition
                            .noTransition, // Nonaktifkan animasi transisi
                      );
                    },
            ),
            IconButton(
              icon: Icon(
                Icons.person,
                color: isSignInOrSignUp
                    ? Colors.white.withOpacity(0.3)
                    : (navigationController.selectedIndex.value == 2
                        ? Colors.white
                        : Colors.white.withOpacity(0.6)),
              ),
              iconSize: 35,
              onPressed: isSignInOrSignUp
                  ? null
                  : () {
                      navigationController.changePage(2);
                      Get.off(
                        () => ProfileView(), // Widget untuk halaman Profile
                        transition: Transition
                            .noTransition, // Nonaktifkan animasi transisi
                      );
                    },
            ),
          ],
        ),
      );
    });
  }
}
