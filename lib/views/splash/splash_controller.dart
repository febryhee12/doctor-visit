import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controller/location_permission.dart';
import '../../controller/notification_permission.dart';
import '../../routes/route_name.dart' as utility;

class SplashController extends GetxController with WidgetsBindingObserver {
  GetStorage box = GetStorage();
  var token = ''.obs;
  var count = 0;

  @override
  void onInit() {
    super.onInit();
    if (box.read('auth_token') != null) {
      token.value = box.read('auth_token');
      // print('Token found: ${token.value}');
    } else {
      // print('No token found');
    }
    checkAndRequestPermissions();
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
