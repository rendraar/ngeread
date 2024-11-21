import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NotificationHandler {
  static void showLoginSuccessNotification() {
    Get.snackbar(
      'Login Successful',
      'You have successfully logged in!',
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
    );
  }

  static void startObserving() {
    WidgetsBinding.instance.addObserver(AppLifecycleObserver());
  }
}
// Observer untuk mendeteksi status aplikasi
class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Menunggu 10 detik sebelum menampilkan notifikasi
      Future.delayed(Duration(seconds: 10), () {
        _showNotification();
      });
    }
  }

  // Tampilkan notifikasi
  void _showNotification() {
    Get.snackbar(
      'Ayo Baca Buku',
      'Saatnya meluangkan waktu untuk membaca buku!',
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 3),
    );
  }
}
