import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var notificationData = ''.obs;

  @override
  void onInit() {
    super.onInit();
    setupFirebase();
  }

  void setupFirebase() {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Minta izin untuk menerima notifikasi di iOS
    messaging.requestPermission();

    // Dapatkan token FCM
    messaging.getToken().then((token) {
      // print('FCM Token: $token');
    });

    // Handle pesan saat aplikasi berada di background
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        notificationData.value = message.notification!.body ?? 'No Body';
        Get.snackbar('Notification', notificationData.value);
      }
    });

    // Handle ketika notifikasi diklik
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        notificationData.value = message.notification!.body ?? 'No Body';
        // Arahkan ke halaman tertentu jika diperlukan
      }
    });
  }
}
