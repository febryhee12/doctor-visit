import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_visit/controller/background_active_location.dart';
import 'package:home_visit/firebase_options.dart';
import 'package:home_visit/controller/notification_c.dart';
import 'package:sizer/sizer.dart';

import 'controller/management_controller.dart';
import 'network/network_binding.dart';
import 'services/http_overrides.dart';

import '/routes/route.dart' as utility;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   // print('Handling a background message: ${message.messageId}');
//   if (message.notification != null) {
//     showNotification(message);
//   }
// }

void main() async {
  // Inisialisasi GetStorage
  await GetStorage.init();
  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Inisialisasi Background Service
  await initializeService();

// Inisialisasi plugin untuk notifikasi lokal
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {
      // Handle notification tap
      String? payload = notificationResponse.payload;
      if (payload != null) {
        // print('Notification payload: $payload');
      }
    },
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification!.body == 'switch_doctor') {
      // Skip showing notification
      flutterLocalNotificationsPlugin.cancelAll();
      listOrderController.listOrder.clear();
      listOrderController.fetchListOrder();
    } else {
      // Show notification
      if (message.notification != null) {
        showNotification(message);
        listOrderController.fetchListOrder();
      }
    }
  });

  // Pastikan Flutter Widgets sudah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Override HTTP untuk keperluan khusus
  HttpOverrides.global = MyHttpOverrides();

  // Sembunyikan keyboard saat start
  SystemChannels.textInput.invokeMethod('TextInput.hide');

  // Pastikan hanya orientasi portrait yang digunakan
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white, // Background putih
          ),
          enableLog: false,
          initialBinding: NetworkBinding(), // Inisialisasi Binding
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.fade,
          initialRoute: utility.Route.initial, // Pastikan route ini benar
          getPages: utility.Route.route, // Pastikan ini juga sudah benar
        );
      },
    );
  }
}
