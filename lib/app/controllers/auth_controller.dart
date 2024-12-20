import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:latihan/app/controllers/navigator_controller.dart';
import 'package:latihan/app/views/auth/signin_view.dart';
import 'package:latihan/app/views/auth/signup_view.dart';
import 'package:latihan/app/views/home_view.dart';

class AuthController extends GetxController {
  final NavigationController navigationController = Get.put(NavigationController());
  static AuthController instance = Get.find();

  // Firebase & Google Sign-In
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // GetStorage instance
  final box = GetStorage();

  RxBool isLoading = false.obs;
  Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    ever(firebaseUser, _setInitialScreen);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      firebaseUser.bindStream(_auth.authStateChanges());
    });
    _monitorConnectivity();
    _uploadPendingData();
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Future.delayed(Duration.zero, () => Get.off(() => SigninView(), transition: Transition.noTransition));
      navigationController.navigateToSignIn();
    } else {
      Future.delayed(Duration.zero, () => Get.off(() => HomeView(), transition: Transition.noTransition));
    }
  }

  // Monitor koneksi internet
  void _monitorConnectivity() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty) {
        final connectivityResult = results.first;
        if (connectivityResult != ConnectivityResult.none) {
          _uploadPendingData();
        }
      }
    });
  }

  bool isAuthenticated() {
    return firebaseUser.value != null;
  }

  // Upload data ke Firestore dengan handling offline
  Future<void> uploadData(Map<String, dynamic> data, String collectionPath) async {
    try {
      await firestore.collection(collectionPath).add(data);
      Get.snackbar("Success", "Data uploaded successfully", backgroundColor: Colors.green);
    } catch (e) {
      // Jika gagal upload, simpan data secara lokal
      _saveDataLocally(data, collectionPath);
      Get.snackbar("Error", "Failed to upload data. Saved locally.", backgroundColor: Colors.orange);
    }
  }


  // Simpan data ke GetStorage
  void _saveDataLocally(Map<String, dynamic> data, String collectionPath) {
    List<Map<String, dynamic>> pendingData =
        box.read<List<Map<String, dynamic>>>("pendingData") ?? [];
    pendingData.add({"data": data, "collectionPath": collectionPath});
    box.write("pendingData", pendingData);
  }

  void uploadPendingData() {
    _uploadPendingData();
  }

  // Upload data yang tertunda ke Firestore
  Future<void> _uploadPendingData() async {
    List<Map<String, dynamic>> pendingData =
        box.read<List<Map<String, dynamic>>>("pendingData") ?? [];

    for (var entry in pendingData) {
      try {
        // Coba upload data ke Firestore
        await firestore.collection(entry['collectionPath']).add(entry['data']);
        // Hapus data yang berhasil diupload dari GetStorage
        _removeDataLocally(entry);
      } catch (e) {
        // Jika gagal upload, biarkan data tetap ada di GetStorage
        print("Failed to upload data: $e");
        break;
      }
    }
  }

  // Hapus data yang berhasil diupload dari GetStorage
  void _removeDataLocally(Map<String, dynamic> entry) {
    List<Map<String, dynamic>> pendingData =
        box.read<List<Map<String, dynamic>>>("pendingData") ?? [];
    pendingData.remove(entry);
    box.write("pendingData", pendingData);
  }

  // Google Sign-In
  Future<void> signInWithGoogle() async {
    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      Get.snackbar("Success", "You are logged in", backgroundColor: Colors.green);
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Failed to sign in: ${e.toString()}", backgroundColor: Colors.red);
    } finally {
      if (Get.isDialogOpen!) Get.back();
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    navigationController.navigateToSignIn();
    Get.off(() => SigninView(), transition: Transition.noTransition);
  }

  // Email & Password Sign-In
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebaseUser.value = userCredential.user;
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Failed to sign in: $e", backgroundColor: Colors.red);
    } finally {
      if (Get.isDialogOpen!) Get.back();
    }
  }

  // Email & Password Registration
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebaseUser.value = userCredential.user;

      // Upload the user details to Firestore
      await firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'password': password,  // It's not recommended to store passwords in plain text
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.off(SignupView());
      Get.snackbar("Success", "Registration successful", backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Error", "Failed to register: $e", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
}
