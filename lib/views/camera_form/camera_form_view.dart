import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_visit/styles/layout.dart';
import 'package:home_visit/widgets/text_lbl.dart';
import 'package:sizer/sizer.dart';
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
        appBar: AppBar(
          title: const Text(
            'Upload Dokumen',
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.toNamed(utility.RouteName.listOrder),
          ),
        ),
        body: Obx(() {
          // Check if patientOrders is empty
          if (controller.patientOrders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
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
                      child: Card(
                        elevation: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 2.0.h),
                                child: TextLbl().label(
                                  data: 'Nama Pasien: ${patient.nama}'
                                      .capitalizes(),
                                  textStyle: TextStyle(fontSize: 12.sp),
                                ),
                              ),
                            ),
                            Obx(() {
                              // Cek apakah daftar images kosong
                              if (patient.images.isEmpty) {
                                return Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.h),
                                    child: const Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_circle_outline,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Upload KTP",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                // Ambil gambar pertama dari daftar images
                                String? imagePath =
                                    controller.getImagePath(index);
                                final imageFile = File(imagePath!);
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: GestureDetector(
                                    onTap: () =>
                                        controller.pickImageFromCamera(index),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          maxHeight:
                                              200, // Max height sesuai ukuran KTP
                                          minWidth:
                                              360, // Min width untuk aspek rasio
                                        ),
                                        child: Image.file(
                                          imageFile,
                                          fit: BoxFit
                                              .cover, // Agar gambar sesuai container
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(2.h),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: buttonVerification(),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  buttonVerification() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () {
            controller.validateAndSubmit();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Submit',
            style: TextStyle(
              color: Colors.white,
            ),
          )),
    );
  }
}
