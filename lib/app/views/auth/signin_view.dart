import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latihan/app/controllers/auth_controller.dart';
import 'package:latihan/app/controllers/navigator_controller.dart';
import 'package:latihan/app/models/custom_bottom_navbar.dart';
import 'package:latihan/app/views/auth/signup_view.dart';
import 'package:latihan/app/views/home_view.dart';

class SigninView extends StatefulWidget {
  @override
  State<SigninView> createState() => _LoginPageState();
}

class _LoginPageState extends State<SigninView> {
  final AuthController _authController = Get.put(AuthController());
  final NavigationController navigationController = Get.put(NavigationController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Sign In Page',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 80),
              _emailAddress(),
              const SizedBox(height: 20),
              _password(),
              const SizedBox(height: 50),
              _signin(context),
              const SizedBox(height: 20),
              _googleSignInButton(),
              const SizedBox(height: 20),
              _signup(context), // Pindahkan ke sini untuk menampilkan teks pendaftaran
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        isEnabled: false,
      ), // Hanya satu panggilan untuk bottomNavigationBar
    );
  }

  Widget _emailAddress() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _password() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          obscureText: true,
          controller: _passwordController,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _signin(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: _authController.isLoading.value
          ? null
          : () async {
        await _authController.signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
        // Jika login berhasil
        if (_authController.isAuthenticated()) {
          navigationController.resetIndex();
          Get.offAll(() => HomeView(), transition: Transition.noTransition);
          Get.snackbar("Success", "You are logged in", backgroundColor: Colors.green);
        }
      },
      child: _authController.isLoading.value
          ? CircularProgressIndicator()
          : Text(
        'Sign In',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _googleSignInButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: () async {
        await _authController.signInWithGoogle();
        if (_authController.isAuthenticated()) {
          navigationController.resetIndex();
          Get.offAll(() => HomeView(), transition: Transition.noTransition);
        }
      },
      child: Text(
        'Sign in with Google',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _signup(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            const TextSpan(
              text: "New User? ",
              style: TextStyle(
                color: Color(0xff6A6A6A),
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: "Create Account",
              style: const TextStyle(
                color: Color(0xff1A1D1E),
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  navigationController.navigateToSignUp();
                  Get.to(() => SignupView());
                },
            ),
          ],
        ),
      ),
    );
  }
}
