import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

GetStorage box = GetStorage();

Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  if (Platform.isIOS || Platform.isAndroid) {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // print('User granted permission');
      // Simpan status izin ke GetStorage atau SharedPreferences
      savePermissionStatus(true);
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      // print('User granted provisional permission');
      savePermissionStatus(true);
    } else {
      // print('User declined or has not accepted permission');
      savePermissionStatus(false);
      // Keluar dari aplikasi jika izin ditolak
      showPermissionDialog();
    }
  }
}

void showPermissionDialog() {
  Get.dialog(
    AlertDialog(
      title: const Text('Akses ditolak'),
      content: const Text(
        'Akses Lokasi dibutuhkan dalam fitur ini. Mohon aktifkan pada setting.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            exitAppIfPermissionDenied(); // Tutup dialog
          },
          child: const Text('Tolak'),
        ),
        TextButton(
          onPressed: () async {
            openAppSettings();
            Get.back();
            showDialog();
          },
          child: const Text('Buka Pengaturan'),
        ),
      ],
    ),
    barrierDismissible: false, // Cegah dialog ditutup dengan klik di luar
  );
}

void showDialog() {
  Get.dialog(
    AlertDialog(
      content: const Text(
        'Restart',
      ),
      actions: [
        Center(
          child: TextButton(
            onPressed: () async {
              exitAppIfPermissionDenied();
            },
            child: const Text('Ok'),
          ),
        ),
      ],
    ),
    barrierDismissible: false, // Cegah dialog ditutup dengan klik di luar
  );
}

void exitAppIfPermissionDenied() {
  if (Platform.isAndroid) {
    SystemNavigator.pop(); // Menutup aplikasi di Android
  } else if (Platform.isIOS) {
    exit(0); // Keluar aplikasi di iOS (hanya jika benar-benar diperlukan)
  }
}

void savePermissionStatus(bool isGranted) {
  box.write('notification_permission', isGranted);
}
