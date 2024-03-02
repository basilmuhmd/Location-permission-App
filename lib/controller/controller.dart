import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:notificatio_and_location_permission/controller/provider.dart';
import 'package:notificatio_and_location_permission/main.dart';
import 'package:notificatio_and_location_permission/model/model_button.dart';

Future<bool> isLocationEnabled() async {
  return await Geolocator.isLocationServiceEnabled();
}

Future<bool> requestLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  String msgtoShow;
  bool isPermissionGranted = true;
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      msgtoShow = 'Location Permission Denied';
      isPermissionGranted = false;
    } else {
      msgtoShow = 'Location permission granted';
    }
  } else {
    msgtoShow = 'Location permission already granted';
  }

  if (permission == LocationPermission.deniedForever) {
    msgtoShow = 'Location denied forever';
    isPermissionGranted = false;
  }
  MyApp.scaffoldMessangerKey.currentState!.showSnackBar(
    SnackBar(
      content: Text(msgtoShow),
    ),
  );
  return isPermissionGranted;
}

List<dynamic> btnList = [
  ButtonModel(
    btnname: "Request Location Permission",
    btnColor: const Color(0xFF2f80ed),
    onTap: (ref, context) async {
      if (await isLocationEnabled()) {
        /// Check if the app has permission
        if (await requestLocationPermission()) {
          print('Location permission granted');
        } else {
          print('Location permission denied');
        }
      } else {
        print('Location not enabled');
      }
    },
  ),
  ButtonModel(
    btnname: "Request Notification Permission",
    btnColor: const Color(0xFFf2c94c),
    onTap: (ref, context) {
      log("message");
      AwesomeNotifications().requestPermissionToSendNotifications();
    },
  ),
  ButtonModel(
    btnname: "Start Location Update",
    btnColor: const Color(0xff27ae60),
    onTap: (ref, context) async {
      if (await requestLocationPermission()) {
        Future.sync(() => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Alert'),
                  content: const Text("Are You Sure"),
                  actions: [
                    TextButton(
                        onPressed: (() {
                          Navigator.pop(context);
                        }),
                        child: const Text('No')),
                    Consumer(
                      builder: (_, ref, __) {
                        return TextButton(
                          onPressed: () {
                            ref
                                .read(locationStateProvider.notifier)
                                .startLocationPolling();
                            AwesomeNotifications().createNotification(
                              content: NotificationContent(
                                id: 5,
                                channelKey: 'location-update',
                                actionType: ActionType.Default,
                                title: 'Location update started',
                              ),
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Yes'),
                        );
                      },
                    )
                  ],
                );
              },
            ));
      } else {
        Future.sync(() => showDialog(
              context: context,
              builder: ((context) {
                return const AlertDialog(
                  title: Text('Alert'),
                  content: Text('Please Enable Location permission'),
                );
              }),
            ));
      }
    },
  ),
  ButtonModel(
    btnname: 'Stop Location Update',
    btnColor: const Color(0xFFeb5757),
    onTap: (ref, context) {
      Future.sync(
        () => showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              title: const Text('Alert'),
              content:
                  const Text('Are you sure you want to stop location update'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No"),
                ),
                Consumer(builder: (context, ref, _) {
                  return ElevatedButton(
                    onPressed: () {
                      ref
                          .read(locationStateProvider.notifier)
                          .stopLocationPolling();
                      AwesomeNotifications().createNotification(
                        content: NotificationContent(
                          id: 6,
                          channelKey: 'location-update',
                          actionType: ActionType.Default,
                          title: 'Location update stoped',
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text("Yes"),
                  );
                }),
              ],
            );
          }),
        ),
      );
    },
  )
];
