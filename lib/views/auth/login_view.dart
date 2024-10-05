import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes/controllers/auth_controller.dart';
import 'package:tes/views/auth/signup_view.dart';

class LogInPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: authController.emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: authController.passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                authController.login(
                  authController.emailController.text,
                  authController.passwordController.text,
                );
              },
              child: Text('Sign In'),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => SignUpPage()); // Navigasi ke halaman signup
              },
              child: Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
