import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

// Future<void> requestCameraPermission() async {
//     var status = await Permission.camera.status;
//     if (!status.isGranted) {
//       status = await Permission.camera.request();
//       if (!status.isGranted) {
//         Get.snackbar(
//           'Permission Denied',
//           'Camera permission is required to use this feature. The app will now exit.',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         await Future.delayed(
//             const Duration(seconds: 2)); // wait for user to see the message
//         SystemNavigator.pop(); // Close the app
//       }
//     }
//   }

GetStorage box = GetStorage();

Future<void> requestCameraPermission() async {
  var status = await Permission.camera.status;

  if (!status.isGranted) {
    status = await Permission.camera.request();

    if (!status.isGranted) {
      // Jika pengguna menolak izin, tampilkan snackbar dengan opsi ke pengaturan
      showPermissionDialog();
      savePermissionStatus(false); // Simpan status penolakan izin
    } else {
      savePermissionStatus(true); // Simpan status jika izin diberikan
      // print('Izin kamera diberikan.');
    }
  } else {
    savePermissionStatus(true); // Izin sudah diberikan
    // print('Izin kamera sudah diaktifkan.');
  }
}

void showPermissionDialog() {
  Get.dialog(
    AlertDialog(
      title: const Text('Akses ditolak'),
      content: const Text(
        'Akses kamera dibutuhkan dalam fitur ini. Mohon aktifkan pada setting.',
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
            openAppSettings(); // Arahkan ke pengaturan aplikasi
          },
          child: const Text('Buka Pengaturan'),
        ),
      ],
    ),
    barrierDismissible: false, // Cegah dialog ditutup dengan klik di luar
  );
}

void savePermissionStatus(bool isGranted) {
  box.write('camera_permission', isGranted);
}

void exitAppIfPermissionDenied() {
  if (Platform.isAndroid) {
    SystemNavigator.pop(); // Menutup aplikasi di Android
  } else if (Platform.isIOS) {
    exit(0); // Keluar aplikasi di iOS
  }
}
