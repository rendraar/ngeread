import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes/controllers/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController()); // Mengambil instance AuthController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authController.logout(); // Fungsi logout ketika menekan tombol logout
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Biodata',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: authController.emailController, // Menggunakan controller dari AuthController
              decoration: InputDecoration(labelText: 'Email'),
              readOnly: true, // Email tidak dapat diedit
            ),
            SizedBox(height: 20),
            TextField(
              controller: authController.passwordController, // Untuk menampilkan password
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Membuat controller untuk input password baru
                TextEditingController newPasswordController = TextEditingController();

                // Menampilkan dialog untuk mengubah password
                Get.defaultDialog(
                  title: "Update Password",
                  content: TextField(
                    controller: newPasswordController, // Controller untuk input password baru
                    decoration: InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                  ),
                  confirm: ElevatedButton(
                    onPressed: () {
                      String newPassword = newPasswordController.text.trim();
                      if (newPassword.isNotEmpty) {
                        authController.updatePassword(newPassword); // Memanggil fungsi updatePassword
                        Get.back(); // Menutup dialog
                      } else {
                        Get.snackbar("Error", "Password cannot be empty");
                      }
                    },
                    child: Text("Update"),
                  ),
                  cancel: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Menutup dialog
                    },
                    child: Text("Cancel"),
                  ),
                );
              },
              child: Text('Update Password'),
            ),
            SizedBox(height: 20),
            // Bisa ditambahkan lebih banyak field untuk informasi biodata
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman lain jika diperlukan
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
