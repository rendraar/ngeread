import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget {
  static const String route = '/notification';

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text('Notification')),
      body: Center(
        child: Text('Received Notification: $arguments'),
      ),
    );
  }
}
