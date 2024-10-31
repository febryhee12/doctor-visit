import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_visit/helpers/dialog.dart';
import '../../services/api_services.dart';
import '../../services/base_client.dart';
import '../../services/base_controller.dart';

import '/routes/route_name.dart' as utility;

class AuthController extends GetxController with BaseController {
  final formKey = GlobalKey<FormState>();
  GetStorage box = GetStorage();

  var hidden = true.obs;
  var isButtonEnabled = false.obs;
  final isTextFieldUserEmpty = true.obs;
  final isTextFieldPassEmpty = true.obs;

  late TextEditingController username;
  late TextEditingController password;

  @override
  void onInit() {
    super.onInit();
    String? savedUsername = box.read('save_username');
    username = TextEditingController(text: savedUsername ?? '');
    password = TextEditingController(text: '');

    username.addListener(_checkButtonState);
    password.addListener(_checkButtonState);
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  void _checkButtonState() {
    // Cek apakah username dan password sudah diisi
    isButtonEnabled.value =
        username.text.isNotEmpty && password.text.isNotEmpty;
  }

  Future<void> auth() async {
    DialogHelper2.showLoading();
    var response = await BaseClient()
        .postWOH(ApiEndPoint.baseUrl, ApiEndPoint.authEndPoints.auth, {
      "username": username.text,
      "password": password.text,
    }).catchError(handleError);

    if (response == null) return;
    var data = await json.decode(response);
    FocusManager.instance.primaryFocus?.unfocus();
    DialogHelper2.hideLoading();
    if (data['status'] == 'Success') {
      try {
        var token = data['data']['token'].toString();
        await authAccess(token);
      } catch (e) {
        throw Exception(e.toString());
      }
    } else if (data['status'] == 'Error') {
      Get.snackbar('Maaf', 'Username atau password salah');
    }
    DialogHelper2.hideLoading();
  }

  Future<void> authAccess(String token) async {
    await box.write('save_username', username.text);
    await box.write("auth_token", token);
    await Get.offAllNamed(
      utility.RouteName.listOrder,
    );
  }
}
