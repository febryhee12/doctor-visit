import 'package:get/get.dart';
import 'package:home_visit/views/camera_form/camera_form_controller.dart';

class CameraFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CameraFormController());
  }
}
