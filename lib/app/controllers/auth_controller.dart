import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:latihan/app/controllers/navigator_controller.dart';
import 'package:latihan/app/views/auth/signin_view.dart';
import 'package:latihan/app/views/auth/signup_view.dart';
import 'package:latihan/app/views/home_view.dart';

class AuthController extends GetxController {
  final NavigationController navigationController = Get.put(NavigationController());
  static AuthController instance = Get.find();

  // FirebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  RxBool isLoading = false.obs;
  // Observable User
  Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    ever(firebaseUser, _setInitialScreen);
    // Memastikan aplikasi siap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      firebaseUser.bindStream(_auth.authStateChanges());
    });
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Future.delayed(Duration.zero, () => Get.off(
            () => SigninView(), // Widget untuk halaman Profile
        transition: Transition.noTransition, // Nonaktifkan animasi transisi
      ));
      navigationController.navigateToSignIn();
    } else {
      Future.delayed(Duration.zero, () => Get.off(() => HomeView(), transition: Transition.noTransition));
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("User canceled the sign-in");
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      Get.snackbar("Success", "You are logged in", backgroundColor: Colors.green);
    } catch (e) {
      // Hentikan loading indicator terlebih dahulu sebelum menampilkan snackbar
      Get.back(); // Tutup dialog loading
      Get.snackbar("Error", "Failed to sign in: ${e.toString()}", backgroundColor: Colors.red, duration: Duration(seconds: 5));
    } finally {
      // Pastikan loading dialog ditutup
      if (Get.isDialogOpen!) {
        Get.back(); // Tutup dialog loading jika masih terbuka
      }
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut(); // Pastikan Firebase logout juga dilakukan
    navigationController.navigateToSignIn();
    Get.off(
          () => SigninView(), // Widget untuk halaman Profile
      transition: Transition.noTransition, // Nonaktifkan animasi transisi
    );
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return firebaseUser.value != null;
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Set firebaseUser dengan user yang berhasil login
      firebaseUser.value = userCredential.user;

    } catch (e) {
      // Hentikan loading indicator terlebih dahulu sebelum menampilkan snackbar
      Get.back(); // Tutup dialog loading
      Get.snackbar("Error", "Failed to sign in: ${e.toString()}", backgroundColor: Colors.red, duration: Duration(seconds: 5));
    } finally {
      // Pastikan loading dialog ditutup
      if (Get.isDialogOpen!) {
        Get.back(); // Tutup dialog loading jika masih terbuka
      }
    }
  }

  // Register with email and password
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebaseUser.value = userCredential.user;
      Get.off(SignupView());
      Get.snackbar("Success", "Registration successful", backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Error", "Failed to register: $e", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
}
