import 'package:get/get.dart';
import 'package:home_visit/views/detail_order/detail_order_controller.dart';

class DetailOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailOrderController());
  }
}
