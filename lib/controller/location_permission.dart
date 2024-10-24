import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

GetStorage box = GetStorage();

Future<void> handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Memastikan layanan lokasi aktif.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  while (!serviceEnabled) {
    // Tampilkan dialog jika layanan lokasi belum aktif
    await showLocationServiceDialog();
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
  }

  // Memeriksa status izin lokasi.
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      savePermissionStatus(false); // Simpan status penolakan izin
      showPermissionDialog();
    }
  }

  if (permission == LocationPermission.deniedForever) {
    savePermissionStatus(false); // Simpan status penolakan permanen
    showPermissionDialog();
  }

  // Izin diberikan, simpan status.
  savePermissionStatus(true);
}

void exitAppIfPermissionDenied() {
  if (Platform.isAndroid) {
    SystemNavigator.pop(); // Menutup aplikasi di Android
  } else if (Platform.isIOS) {
    exit(0); // Keluar aplikasi di iOS (hanya jika benar-benar diperlukan)
  }
}

Future<void> showLocationServiceDialog() async {
  return Get.dialog(
    AlertDialog(
      title: const Text('Location Service Disabled'),
      content: const Text(
        'Location services are required to use this feature. Please enable them in settings.',
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await Geolocator
                .openLocationSettings(); // Arahkan ke pengaturan lokasi
            await Future.delayed(const Duration(seconds: 2));
            // restartApp();
          },
          child: const Text('Buka Pengaturan'),
        ),
        TextButton(
          onPressed: () {
            exitAppIfPermissionDenied(); // Keluar dari aplikasi jika layanan tetap tidak aktif
          },
          child: const Text('Tolak'),
        ),
      ],
    ),
    barrierDismissible: false, // Cegah dialog ditutup dengan klik di luar
  );
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

void savePermissionStatus(bool isGranted) {
  box.write('location_permission', isGranted);
}
