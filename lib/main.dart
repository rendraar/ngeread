import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:latihan/dependency_injection.dart';
import 'app/controllers/auth_controller.dart';
import 'app/controllers/notification_controller.dart';
import 'app/views/auth/signin_view.dart';
import 'app/views/home_view.dart';
import 'app/views/notification_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inisialisasi Firebase
  await NotificationController().initNotification();
  await dotenv.load(fileName: ".env");
  DependencyInjection.init();

  Get.lazyPut<AuthController>(() => AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
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
        GetPage(
          name: NotificationView.route,
          page: () => NotificationView(),
        ),
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
        return HomeView();
      } else {
        return SigninView();
      }
    });
  }
}
