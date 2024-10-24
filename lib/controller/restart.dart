import 'package:get/get.dart';

import '../../routes/route_name.dart' as utility;

void restartApp() {
  Future.delayed(const Duration(milliseconds: 100), () {
    Get.offAll(utility.RouteName.splash);
  });
}
