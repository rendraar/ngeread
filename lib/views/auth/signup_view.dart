import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes/controllers/auth_controller.dart';

class SignUpPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: authController.emailController,  // Menggunakan controller dari AuthController
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: authController.passwordController,  // Menggunakan controller dari AuthController
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Panggil fungsi signup ketika tombol ditekan
                authController.signup(
                  authController.emailController.text,
                  authController.passwordController.text,
                );
              },
              child: Text('Sign Up'),
            ),
            TextButton(
              onPressed: () {
                Get.back(); // Kembali ke halaman login
              },
              child: Text('Already have an account? Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
