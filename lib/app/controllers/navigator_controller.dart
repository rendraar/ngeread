import 'package:get/get.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;
  var isSignInPage = false.obs;  // Status halaman SignIn
  var isSignUpPage = false.obs;  // Status halaman SignUp

  void changePage(int index) {
    // Mengatur halaman yang dipilih dan menonaktifkan status SignIn/SignUp
    selectedIndex.value = index;
    isSignInPage.value = false;
    isSignUpPage.value = false;
  }

  void navigateToSignIn() {
    isSignInPage.value = true;
    isSignUpPage.value = false;
  }

  void navigateToSignUp() {
    isSignUpPage.value = true;
    isSignInPage.value = false;
  }

  void resetIndex() {
    selectedIndex.value = 0;
    isSignInPage.value = false;
    isSignUpPage.value = false;
  }
}
