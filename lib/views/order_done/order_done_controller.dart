import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../routes/route_name.dart' as utility;

class OrderDoneController extends GetxController {
  GetStorage box = GetStorage();
  var count = 0;

  @override
  void onInit() {
    super.onInit();
    _clearPreviousData();
    _toListOrder();
  }

  void _clearPreviousData() {
    if (box.read('uuid') != null) {
      box.remove('uuid');
    } else {
      return;
    }
    // if (listOrderController.listOrder.isNotEmpty) {
    //   listOrderController.listOrder.clear();
    // } else {
    //   return;
    // }
    // listOrderController.listOrder.clear();
    _removeAllImages();
  }

  void _removeAllImages() {
    final keys = List<String>.from(box.getKeys());

    for (var key in keys) {
      // Pastikan key berupa String dan dimulai dengan 'image_'.
      if (key.startsWith('image_')) {
        box.remove(key);
      } else {
        return;
      }
    }
  }

  Future<void> _toListOrder() async {
    Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        count++;
        if (count > 6) {
          timer.cancel();
          Future.delayed(Duration.zero, () {
            Get.offAndToNamed(utility.RouteName.listOrder);
          });
        }
      },
    );
  }
}
