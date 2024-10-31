import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'status_order_controller.dart';

// ignore: must_be_immutable
class OrderStatus extends StatelessWidget {
  OrderStatus({super.key});

  OrderStatusController orderStatusController =
      Get.put(OrderStatusController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Status Order",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatusStep(
                  icon: Icons.home,
                  label: "Terima",
                  isActive: orderStatusController.currentStatus.value.index >=
                      Status.accept.index,
                ),
                _buildLine(
                    isActive: orderStatusController.currentStatus.value.index >=
                        Status.packed.index),
                _buildStatusStep(
                  icon: Icons.inventory_2,
                  label: "Persiapan",
                  isActive: orderStatusController.currentStatus.value.index >=
                      Status.packed.index,
                ),
                _buildLine(
                    isActive: orderStatusController.currentStatus.value.index >=
                        Status.otw.index),
                _buildStatusStep(
                  icon: Icons.local_shipping,
                  label: "Perjalanan",
                  isActive: orderStatusController.currentStatus.value.index >=
                      Status.otw.index,
                ),
                _buildLine(
                    isActive: orderStatusController.currentStatus.value ==
                        Status.check),
                _buildStatusStep(
                  icon: Icons.checklist,
                  label: "Periksa",
                  isActive:
                      orderStatusController.currentStatus.value == Status.check,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatusStep(
      {required IconData icon, required String label, required bool isActive}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: isActive ? Colors.blue : Colors.grey.shade300,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: TextStyle(color: isActive ? Colors.black : Colors.grey)),
      ],
    );
  }

  Widget _buildLine({required bool isActive}) {
    return Container(
      width: 30,
      height: 2,
      color: isActive ? Colors.blue : Colors.grey.shade300,
      alignment: Alignment.center,
    );
  }
}
