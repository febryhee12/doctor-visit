import 'package:get/get.dart';
import 'package:home_visit/views/auth/auth_binding.dart';
import 'package:home_visit/views/auth/auth_view.dart';
import 'package:home_visit/views/camera_form/camera_form_binding.dart';
import 'package:home_visit/views/camera_form/camera_form_view.dart';
import 'package:home_visit/views/detail_order/detail_order_binding.dart';
import 'package:home_visit/views/list_order/list_order_binding.dart';
import 'package:home_visit/views/list_order/list_order_view.dart';
import 'package:home_visit/views/order/order_binding.dart';
import 'package:home_visit/views/order/order_view.dart';
import 'package:home_visit/views/order_done/order_done.dart';
import 'package:home_visit/views/splash/splash_binding.dart';
import 'package:home_visit/views/splash/splash_view.dart';

import '../views/detail_order/detail_order_view.dart';
import '../views/order_done/order_done_binding.dart';
import 'route_name.dart';

class Route {
  static const initial = RouteName.splash;
  static final route = [
    GetPage(
      name: RouteName.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: RouteName.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: RouteName.listOrder,
      page: () => const ListOrderView(),
      binding: ListOrderBinding(),
    ),
    GetPage(
      name: RouteName.order,
      page: () => const OrderView(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: RouteName.cameraForm,
      page: () => const CameraFormView(),
      binding: CameraFormBinding(),
    ),
    GetPage(
      name: RouteName.detailOrder,
      page: () => const DetailOrderView(),
      binding: DetailOrderBinding(),
    ),
    GetPage(
      name: RouteName.orderDone,
      page: () => const OrderDone(),
      binding: OrderDoneBinding(),
    )
  ];
}
