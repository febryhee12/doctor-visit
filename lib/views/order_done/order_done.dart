import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../styles/layout.dart';
import '../../widgets/text_lbl.dart';
import 'order_done_controller.dart';

class OrderDone extends GetView<OrderDoneController> {
  const OrderDone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }

  body() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(2.h),
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
              textAlign: TextAlign.center,
              data: 'Terima Kasih',
              textStyle:
                  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            TextLbl().label(
              textAlign: TextAlign.center,
              data: 'Input rekam medis berhasil!',
              textStyle: TextStyle(
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
