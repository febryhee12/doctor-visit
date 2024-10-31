import 'package:get/get.dart';
import 'package:home_visit/views/camera_form/camera_form_controller.dart';
import 'package:home_visit/views/detail_order/detail_order_controller.dart';
import 'package:home_visit/views/list_order/status_order_controller.dart';

import '../views/list_order/list_order_controller.dart';

ListOrderController listOrderController = Get.put(ListOrderController());
CameraFormController cameraFormController = Get.put(CameraFormController());
OrderStatusController orderStatusController = Get.put(OrderStatusController());
DetailOrderController detailOrderController = Get.put(DetailOrderController());
