import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:home_visit/main.dart';

Future<void> showNotification(RemoteMessage message) async {
  final BigTextStyleInformation bigTextStyleInformation =
      BigTextStyleInformation(
    message.notification?.body ?? 'Pesan tidak ada',
    contentTitle: message.notification?.title ?? 'Judul tidak ada',
  );

  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id', // ID Saluran
    'your_channel_name', // Nama Saluran
    channelDescription: 'Your channel description',
    importance: Importance.max, // Pastikan notifikasi muncul
    priority: Priority.high, // Prioritas tinggi
    sound: const RawResourceAndroidNotificationSound(
        'notification_sound'), // Suara kustom (opsional)
    playSound: true, // Mainkan suara saat notifikasi muncu l
    styleInformation: bigTextStyleInformation,
    icon: '@mipmap/ic_launcher',
  ); // Gunakan objek yang telah dibuat

  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: const DarwinNotificationDetails(
        presentSound: true, presentAlert: true, presentBadge: true),
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
    payload: 'Notification Payload',
  );
}
