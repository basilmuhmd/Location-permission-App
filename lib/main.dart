import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notificatio_and_location_permission/view/home_page.dart';

void main() {
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'location-update',
      channelName: "Location Update",
      channelDescription: "Notifications of Loacation update status",
    )
  ]);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
