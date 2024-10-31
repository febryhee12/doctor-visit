import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_visit/services/base_controller.dart';

import 'package:intl/intl.dart';

import '../../main.dart';
import '../../model/order_model.dart';
import '../../services/api_services.dart';
import '../../services/base_client.dart';

import '/routes/route_name.dart' as utility;

class DetailOrderController extends GetxController with BaseController {
  GetStorage box = GetStorage();
  var isLoading = false.obs;
  var listOrder = <OrderModel>[].obs;
  var patientOrders = <Pasiens>[].obs;

  RxString cityText = ''.obs;
  RxString districtText = ''.obs;
  var token = ''.obs;

  @override
  void onInit() {
    super.onInit();
    token.value = box.read('auth_token');
    listOrder.value = Get.arguments['order_model'];
    cityText.value = Get.arguments['city'];
    districtText.value = Get.arguments['district'];
  }

  Future<void> getApprove() async {
    var response = await BaseClient().get(
        ApiEndPoint.baseUrl,
        '${ApiEndPoint.authEndPoints.approve}/${listOrder[0].uuid}',
        {'Authorization': 'Bearer ${token.value}'}).catchError(handleError);

    json.decode(response);

    if (response = true) {
      flutterLocalNotificationsPlugin.cancelAll();
      Get.offAllNamed(utility.RouteName.listOrder);
    } else {
      return;
    }
  }

  // Method untuk mengambil waktu (07:00:00)
  String getTime() {
    DateTime dateTime = DateTime.parse('${listOrder[0].waktuKunjung}');
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  // Method untuk mengambil tanggal (1 January 1970)
  String getFormattedDate() {
    DateTime dateTime = DateTime.parse('${listOrder[0].waktuKunjung}');
    return DateFormat('d MMMM yyyy').format(dateTime);
  }
}
