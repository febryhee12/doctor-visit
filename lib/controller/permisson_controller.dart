import 'package:get_storage/get_storage.dart';

import 'location_permission.dart';
import 'notification_permission.dart';

GetStorage box = GetStorage();

Future<void> checkAndRequestPermissions() async {
  await requestNotificationPermission();

  if (box.read('notification_permission') != true) {
    return;
  }
  await handleLocationPermission();

  if (box.read('location_permission') != true) {
    return;
  }
}
