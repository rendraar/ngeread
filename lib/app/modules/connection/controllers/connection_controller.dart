import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:latihan/app/views/auth/signin_view.dart';
import 'package:latihan/app/controllers/auth_controller.dart';

class ConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((connectivityResults) {
      // Jika connectivityResults adalah List<ConnectivityResult>, kita ambil hasil pertama
      final connectivityResult = connectivityResults.first;

      // Update koneksi dan navigasi
      _updateConnectionStatus(connectivityResult);

      // Tampilkan Snackbar setelah navigasi selesai
      Future.delayed(
        Duration.zero,
            () => _showSnackbar(connectivityResult),
      );
    });
  }

  // Fungsi untuk mengupdate status koneksi
  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      _showSnackbar(connectivityResult);
    } else {
      if (Get.currentRoute == '/NoConnectionView') {
        Get.offAll(() => SigninView());
      }
      AuthController.instance.uploadPendingData(); // Pastikan data tertunda diupload ketika koneksi kembali
    }
  }

  // Fungsi untuk menampilkan Snackbar
  void _showSnackbar(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Get.snackbar(
        'Koneksi Hilang',
        'Tidak ada internet',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } else {
      Get.snackbar(
        'Koneksi kembali',
        'Berhasil Terhubung ke internet',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
