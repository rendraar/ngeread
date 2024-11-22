import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:latihan/app/views/auth/signin_view.dart';
import 'package:latihan/app/views/home_view.dart';
import 'app/controllers/auth_controller.dart';
import 'app/controllers/navigator_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inisialisasi Firebase
  await dotenv.load(fileName: ".env");
  Get.lazyPut<AuthController>(() => AuthController());
  Get.lazyPut<NavigationController>(() => NavigationController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: Root(), // Gunakan widget Root untuk menentukan halaman awal
      getPages: [
        GetPage(name: '/login', page: () => SigninView()),
        GetPage(name: '/home', page: () => HomeView()),
        // Anda dapat menambahkan halaman lainnya di sini jika diperlukan
      ],
    );
  }
}

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final authController = Get.find<AuthController>();
      if (authController.isAuthenticated()) {
        return HomeView(); // Ganti HomeView dengan MainNavController
      } else {
        return SigninView();
      }
    });
  }
}
