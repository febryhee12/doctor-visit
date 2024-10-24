import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controller/background_active_location.dart';
import '../../controller/notification_permission.dart';
import '../../controller/permisson_controller.dart';
import '../../main.dart';
import '../../model/doctor_model.dart';
import '../../model/order_model.dart';
import '../../services/api_services.dart';
import '../../services/base_client.dart';

import '../../services/base_controller.dart';
import '/routes/route_name.dart' as utility;

class ListOrderController extends GetxController
    with BaseController, WidgetsBindingObserver {
  GetStorage box = GetStorage();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  // Timer? timer;
  var isLoading = false.obs;

  // var timeLeft = ''.obs;
  var token = ''.obs;
  var namaUser = 'Dokter'.obs;
  var statusOrder = ''.obs;
  var uuid = ''.obs;
  var timeStart = ''.obs;
  var timeAccept = ''.obs;
  var tokenfcm = ''.obs;

  var listOrder = <OrderModel>[].obs;
  var profileUser = DoctorModel(
    name: '',
    username: '',
  ).obs;

  // var time = '2024-10-14 14:45:00'.obs;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    requestFCMTOKEN();
    token.value = box.read('auth_token');
    if (box.read('name_user') == null) {
      fetchProfile();
    } else {
      namaUser.value = box.read('name_user');
    }
    checkAndRequestPermissions();
    fetchListOrder();
    getCurrentLocation();
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    // timer?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // print("Aplikasi masuk ke background");
    } else if (state == AppLifecycleState.resumed) {
      // print("Aplikasi kembali ke foreground");
      fetchListOrder();
    }
  }

  Future<void> onReload() async {
    await fetchListOrder();
    await getCurrentLocation();
  }

  // void startCountdown(dateTime) {
  //   String dateTimeString = dateTime;
  //   DateTime targetDateTime = DateTime.parse(dateTimeString);
  //   timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     final now = DateTime.now();
  //     final difference = targetDateTime.difference(now);

  //     if (difference.isNegative) {
  //       timer.cancel();
  //       timeLeft.value = timeStart.value;
  //       fetchListOrder();
  //     } else {
  //       final hours = difference.inHours.toString().padLeft(2, '0');
  //       final minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
  //       final seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');
  //       timeLeft.value = "$hours : $minutes : $seconds";
  //     }
  //   });
  // }

  Future<void> requestFCMTOKEN() async {
    tokenfcm.value = (await FirebaseMessaging.instance.getToken())!;
    // print("Firebase Messaging Token: $tokenfcm");
    var response = await BaseClient()
        .post(ApiEndPoint.clinicUrl, ApiEndPoint.authEndPoints.storeToken, {
      'Authorization': 'Bearer ${token.value}'
    }, {
      'device_token': tokenfcm.value,
    }).catchError(handleError);

    if (response != null) return;
  }

  Future<void> checkNotificationPermission() async {
    bool? isGranted = box.read('notification_permission');

    if (isGranted == null || !isGranted) {
      await requestNotificationPermission();
    }
  }

  //mendapatkan model user
  Future<DoctorModel?> getProfile() async {
    if (token.value != '') {
      var response = await BaseClient().get(
          ApiEndPoint.baseUrl,
          ApiEndPoint.authEndPoints.profile,
          {'Authorization': 'Bearer ${token.value}'}).catchError(handleError);
      var data = json.decode(response);
      var jsonStr = data['data'];
      return DoctorModel.fromJson(jsonStr);
    }
    return null;
  }

  //check model user
  Future<void> fetchProfile() async {
    var profile = await getProfile();
    if (profile != null) {
      try {
        // Tampilkan loading dialog
        // Panggil API atau proses asinkron lainnya
        profileUser.value = profile;
      } finally {
        // Sembunyikan loading dialog
        namaUser.value = profile.name!;
        box.write('name_user', profile.name);
      }
    }
  }

  Future<List<OrderModel>?> getListOrder() async {
    var response = await BaseClient().get(
        ApiEndPoint.baseUrl,
        ApiEndPoint.authEndPoints.aktif,
        {'Authorization': 'Bearer ${token.value}'}).catchError(handleError);

    var responData = json.decode(response);

    if (response = true) {
      List<dynamic> arr = responData["data"];
      List<OrderModel> result = [];
      // ignore: avoid_function_literals_in_foreach_calls
      arr.forEach(
        (x) {
          result.add(OrderModel.fromJson(x));
        },
      );
      return result;
    } else {
      return null;
    }
  }

  Future<void> fetchListOrder() async {
    isLoading.value = true;
    try {
      var list = await getListOrder();
      if (list != null && list.isNotEmpty) {
        listOrder.assignAll(list);
        uuid.value = '${listOrder[0].uuid}';
        statusOrder.value = '${listOrder[0].status}';
        // timeAccept.value = '${listOrder[0].datetimeAccept}';
        // timeStart.value = '${listOrder[0].datetimeStart}';
        // print(timeStart.value);
        // print(timeAccept.value);
        // print(listOrder[0].namaPemesan);
        // print(listOrder[0].waktuKunjung);
        // print(listOrder[0].phone);
        // print(listOrder[0].pasiens![0].keluhan);
        // print(listOrder[0].alamat);
        // print(listOrder[0].status);
        // print(listOrder[0].datetimeStart);
        // time.value = '${listOrder[0].datetimeStart}';
        // time.value = '2024-10-14 15:02:00';
        // startCountdown(timeStart.value);
        // Optionally start countdown if needed
        // if (timeAccept.value == '') {
        //   startCountdown('2024-10-17 17:15:44');
        // } else {
        //   return;
        // }
      } else {
        return;
        // Handle the case where the list is null or empty
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getApprove() async {
    var response = await BaseClient().get(
        ApiEndPoint.baseUrl,
        '${ApiEndPoint.authEndPoints.approve}/${uuid.value}',
        {'Authorization': 'Bearer ${token.value}'}).catchError(handleError);

    json.decode(response);

    if (response = true) {
      onReload();
      flutterLocalNotificationsPlugin.cancelAll();
      Get.toNamed(utility.RouteName.detailOrder, arguments: {
        'order_model': listOrder,
      });
    } else {
      return;
    }
  }

  Future<void> getPrepare() async {
    var response = await BaseClient().get(
        ApiEndPoint.baseUrl,
        '${ApiEndPoint.authEndPoints.persiapan}/${uuid.value}',
        {'Authorization': 'Bearer ${token.value}'}).catchError(handleError);

    json.decode(response);

    if (response = true) {
      onReload();
    } else {
      return;
    }
  }

  Future<void> getOnGoing() async {
    var response = await BaseClient().get(
        ApiEndPoint.baseUrl,
        '${ApiEndPoint.authEndPoints.perjalanan}/${uuid.value}',
        {'Authorization': 'Bearer ${token.value}'}).catchError(handleError);

    json.decode(response);

    if (response = true) {
      startBackgroundService();
      onReload();
    } else {
      return;
    }
  }

  Future<void> getVerification() async {
    var response = await BaseClient().get(
        ApiEndPoint.baseUrl,
        '${ApiEndPoint.authEndPoints.pemerikasaan}/${uuid.value}',
        {'Authorization': 'Bearer ${token.value}'}).catchError(handleError);

    json.decode(response);

    if (response = true) {
      stopBackgroundService();
      onReload();
    } else {
      return;
    }
  }

  Future<void> sentActiveLocation(
      {String? currLongitude, String? currLatitude}) async {
    var response = await BaseClient()
        .post(ApiEndPoint.baseUrl, ApiEndPoint.authEndPoints.currentLocation, {
      'Authorization': 'Bearer ${token.value}'
    }, {
      'longitude': currLongitude,
      'latitude': currLatitude,
      'uuid_order': uuid.value,
    }).catchError(handleError);

    jsonDecode(response);
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    String latitude = position.latitude.toStringAsFixed(6); // Format 6 desimal
    String longitude =
        position.longitude.toStringAsFixed(6); // Format 6 desimal

    var response = await BaseClient()
        .post(ApiEndPoint.baseUrl, ApiEndPoint.authEndPoints.currentLocation, {
      'Authorization': 'Bearer ${token.value}'
    }, {
      'longitude': longitude,
      'latitude': latitude,
    }).catchError(handleError);

    var responesData = jsonDecode(response);
    if (responesData['status'] == 'Success') return;
  }

  Future<void> logout() async {
    await FirebaseMessaging.instance.deleteToken();
    await box.remove("name_user");
    await box.remove("auth_token");
    Get.offAllNamed(utility.RouteName.splash);
  }
}
