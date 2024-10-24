import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_visit/styles/color.dart';
import 'package:home_visit/widgets/text_btn.dart';
import 'package:home_visit/widgets/text_lbl.dart';
import 'package:sizer/sizer.dart';

import '../styles/layout.dart';

class DialogHelper {
  static void showErrorDialog(
      {String? title = 'Maaf', String? description = 'Terjadi kesalahan'}) {
    Get.dialog(
      Dialog(
        child: SizedBox(
          child: Padding(
            padding: EdgeInsets.all(2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextLbl().label(
                    data: '$title',
                    textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        // color: ReliOtoColors.primary),
                        color: Colors.black87),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 2.h,
                ),
                TextLbl().label(
                    data: '$description',
                    textStyle: TextStyle(
                      fontSize: 11.sp,
                    ),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 2.h,
                ),
                TextBtn().button(
                  width: Layout.width,
                  onPressed: () {
                    if (description ==
                        "Tidak terhubung dengan jaringan internet") {
                      Get.back();
                    } else {
                      Get.back();
                    }
                  },
                  label: "Tutup",
                  border: Border.all(color: HVColors.primary),
                  backgroundColor: HVColors.primary,
                  textStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 1.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showLoading() {
    Get.dialog(
      barrierDismissible: false,
      const Center(child: CircularProgressIndicator()),
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen!) Get.back();
  }
}
