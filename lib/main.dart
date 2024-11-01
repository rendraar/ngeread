import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes/controllers/notification_controller.dart';
import 'package:tes/views/home_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tes/views/notification/notification_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationController().initNotification();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
      routes: {
        NotificationView.route: (context) => const NotificationView(),
      },
    );
  }
}
