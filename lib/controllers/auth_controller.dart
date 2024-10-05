import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tes/views/auth/login_view.dart';
import 'package:tes/views/home_view.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var user = Rxn<User>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
    ever(user, _setInitialScreen);
  }

  // Navigasi ke halaman utama setelah login berhasil
  _setInitialScreen(User? firebaseUser) {
    if (firebaseUser == null) {
      Get.offAll(() => LogInPage());
    } else {
      Get.offAll(() => HomeView());  // Arahkan ke halaman utama setelah login
    }
  }

  // Fungsi login
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Fungsi signup
  Future<void> signup(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user.value = userCredential.user;
      Get.snackbar("Success", "Account created successfully. Please log in.");
      // Alihkan ke halaman login setelah signup berhasil
      Get.offAll(() => LogInPage());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Fungsi untuk memperbarui password
  Future<void> updatePassword(String newPassword) async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      try {
        await firebaseUser.updatePassword(newPassword);
        Get.snackbar("Success", "Password updated successfully");
      } catch (e) {
        Get.snackbar("Error", e.toString());
      }
    }
  }


  // Fungsi logout
  void logout() async {
    await _auth.signOut();
  }
}
