import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget{
  const NotificationView({Key? key}) : super(key: key);
  static const route = "/notif_screen";
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Text("notif screen here")
      ],
    );
  }
}