import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_visit/styles/color.dart';
import 'package:home_visit/styles/layout.dart';
import 'package:home_visit/widgets/text_lbl.dart';
import 'package:sizer/sizer.dart';
import '../../widgets/text_btn.dart';
import 'camera_form_controller.dart';
import '/routes/route_name.dart' as utility;

class CameraFormView extends GetView<CameraFormController> {
  const CameraFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => Get.toNamed(utility.RouteName.listOrder),
      child: Scaffold(
        backgroundColor: HVColors.flashWhite,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Upload Dokumen',
            style: TextStyle(fontSize: 16),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.toNamed(utility.RouteName.listOrder),
          ),
        ),
        body: Obx(() {
          if (controller.patientOrders.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: HVColors.primary,
              ),
            );
          }

          return Stack(
            children: [
              ListView.builder(
                itemCount: controller.patientOrders.length,
                itemBuilder: (context, index) {
                  final patient = controller.patientOrders[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => controller.pickImageFromCamera(index),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 1.h),
                            child: Row(
                              children: [
                                TextLbl().label(
                                  data: 'Nama Pasien: ',
                                  textStyle: TextStyle(fontSize: 12.sp),
                                ),
                                TextLbl().label(
                                  data: '${patient.nama}'.capitalizes(),
                                  textStyle: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Card(
                            color: Colors.white,
                            elevation: 0,
                            child: Obx(() {
                              if (patient.images.isEmpty) {
                                return _buildEmptyImagePlaceholder();
                              } else {
                                String? imagePath =
                                    controller.getImagePath(index);
                                final imageFile = File(imagePath!);
                                return _buildImagePreview(imageFile, index);
                              }
                            }),
                          ),
                          SizedBox(height: 1.h),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(2.h),
                  decoration: const BoxDecoration(color: HVColors.flashWhite),
                  child: buttonVerification(),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildEmptyImagePlaceholder() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle_outline, size: 40, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              "Upload KTP",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(File imageFile, int index) {
    return SizedBox(
      height: 200,
      width: 360,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => controller.pickImageFromCamera(index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 200,
                minWidth: 360,
              ),
              child: Image.file(imageFile, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }

  buttonVerification() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: TextBtn().button(
        onPressed: () {
          controller.validateAndSubmit();
        },
        backgroundColor: HVColors.primary,
        textStyle: const TextStyle(color: Colors.white),
        label: 'Selanjutnya',
      ),
    );
  }
}
