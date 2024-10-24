import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Layout {
  final context = Get.context;

  static final width = MediaQuery.of(Get.context!).size.width;
  static final height = MediaQuery.of(Get.context!).size.height;
}

extension StringExtension on String {
  String capitalizes() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
