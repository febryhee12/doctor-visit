import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_visit/styles/color.dart';

class DialogHelper2 {
  static void showLoading() {
    // Memastikan dialog hanya muncul setelah build selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            color: HVColors.primary,
          ),
        ),
        barrierDismissible: false,
      );
    });
  }

  static void hideLoading() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}
