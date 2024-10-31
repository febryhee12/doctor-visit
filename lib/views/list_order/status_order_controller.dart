import 'package:get/get.dart';
import 'package:home_visit/controller/management_controller.dart';

enum Status { accept, packed, otw, check, fail }

class OrderStatusController extends GetxController {
  var currentStatus = Status.fail.obs;

  void checkStatus() {
    if (listOrderController.statusOrder.value == 'Dokter Approval') {
      updateStatus(Status.accept);
    } else if ((listOrderController.statusOrder.value == 'Persiapan Dokter')) {
      updateStatus(Status.packed);
    } else if (listOrderController.statusOrder.value == 'Perjalanan Dokter') {
      updateStatus(Status.otw);
    } else if (listOrderController.statusOrder.value == 'Pemeriksaan Dokter') {
      updateStatus(Status.check);
    } else {
      updateStatus(Status.fail);
    }
  }

  void updateStatus(Status status) {
    currentStatus.value = status;
    update();
  }
}
