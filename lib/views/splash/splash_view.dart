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
        body: body(),
      ),
    );
  }

  body() {
    return Center(
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
              data: 'Home Visit',
              textStyle: TextStyle(
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
