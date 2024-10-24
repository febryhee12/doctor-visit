import 'package:get/get.dart';
import 'network_controller.dart';

class NetworkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NetworkController>(() => NetworkController());
  }
}
