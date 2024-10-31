import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_visit/widgets/text_lbl.dart';
import 'package:sizer/sizer.dart';

import '../../styles/layout.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        return;
      },
      child: Scaffold(
        body: Obx(
          () => body(),
        ),
      ),
    );
  }

  body() {
    return Stack(
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.all(6.h),
            height: double.infinity,
            width: Layout.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120,
                  child: Image.asset(
                    'assets/image.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 2.5.h,
                ),
                TextLbl().label(
                  data: 'Doctor Visit',
                  textStyle: TextStyle(
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Text(controller.version.value),
          ),
        )
      ],
    );
  }
}
