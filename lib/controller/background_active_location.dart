import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';

import 'management_controller.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: false,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      autoStart: false,
    ),
  );
}

void onStart(ServiceInstance service) async {
  final storage = GetStorage();
  storage.write('serviceRunning', true); // Simpan status service

  if (service is AndroidServiceInstance) {
    // Set foreground notification dengan informasi kustom
    service.setForegroundNotificationInfo(
      title: "Lokasi",
      content: "Dokter dalam perjalanan menuju lokasi pasien",
    );
  }

  // Handler untuk menghentikan service
  service.on('stopService').listen((event) async {
    storage.write('serviceRunning', false); // Perbarui status service
    service.stopSelf(); // Hentikan service
  });

  Timer.periodic(const Duration(minutes: 2), (timer) async {
    if (storage.read('serviceRunning') == false) {
      timer.cancel(); // Hentikan timer jika service berhenti
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String latitude =
          position.latitude.toStringAsFixed(6); // Format 6 desimal
      String longitude =
          position.longitude.toStringAsFixed(6); // Format 6 desimal

      listOrderController.sentActiveLocation(
          currLatitude: latitude, currLongitude: longitude);

      service.invoke(
        'update',
        {
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
      );
    } catch (e) {
      // print('Error getting location: $e');
    }
  });
}

void startBackgroundService() async {
  bool isRunning = await FlutterBackgroundService().isRunning();
  if (!isRunning) {
    await FlutterBackgroundService().startService();
    // Get.snackbar('Service Started', 'Background service has started.');
  } else {
    return;
    // Get.snackbar('Service Running', 'Service is already running.');
  }
}

// Fungsi untuk menghentikan service
void stopBackgroundService() async {
  bool isRunning = await FlutterBackgroundService().isRunning();
  if (isRunning) {
    FlutterBackgroundService().invoke('stopService');
    // Get.snackbar('Service Stopped', 'Background service has been stopped.');
  } else {
    return;
    // Get.snackbar('Service Not Running', 'The service is not running.');
  }
}
