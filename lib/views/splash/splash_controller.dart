import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../controller/location_permission.dart';
import '../../controller/notification_permission.dart';
import '../../routes/route_name.dart' as utility;

class SplashController extends GetxController {
  GetStorage box = GetStorage();
  var token = ''.obs;
  var count = 0;
  var version = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (box.read('auth_token') != null) {
      token.value = box.read('auth_token');
      // print('Token found: ${token.value}');
    } else {
      // print('No token found');
    }
    getVersion();
    checkAndRequestPermissions();
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
    box.write('version', version.value);
  }

  Future<void> checkAndRequestPermissions() async {
    await requestNotificationPermission();

    if (box.read('notification_permission') != true) {
      return;
    }
    await handleLocationPermission();

    if (box.read('location_permission') != true) {
      return;
    }
    startSplash();
  }

  Future<void> startSplash() async {
    Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        count++;
        if (count > 13) {
          timer.cancel();
          Future.delayed(Duration.zero, () {
            if (token.value == '') {
              Get.toNamed(utility.RouteName.auth);
            } else {
              Get.offAndToNamed(utility.RouteName.listOrder);
            }
          });
        }
      },
    );
  }
}
