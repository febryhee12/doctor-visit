import 'package:get/get.dart';
import 'package:home_visit/views/order_done/order_done_controller.dart';

class OrderDoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OrderDoneController());
  }
}
