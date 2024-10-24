import 'package:get/get.dart';
import 'package:home_visit/views/list_order/list_order_controller.dart';

class ListOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ListOrderController());
  }
}
