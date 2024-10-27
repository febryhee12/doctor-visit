import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_visit/styles/layout.dart';
import 'package:home_visit/views/list_order/list_order_controller.dart';
import 'package:home_visit/widgets/text_btn.dart';
import 'package:home_visit/widgets/text_lbl.dart';
import 'package:sizer/sizer.dart';

import '../../controller/google_maps.dart';
import '../../styles/color.dart';
import '/routes/route_name.dart' as utility;

class ListOrderView extends GetView<ListOrderController> {
  const ListOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => false,
      child: Scaffold(
        backgroundColor: HVColors.flashWhite,
        appBar: appBar(),
        body: Obx(
          () {
            if (controller.isLoading.value == true) {
              return const Center(
                child: CircularProgressIndicator(
                  color: HVColors.primary,
                ),
              );
            } else if (controller.listOrder.isNotEmpty) {
              return body();
            } else {
              return RefreshIndicator(
                color: HVColors.primary,
                key: controller.refreshKey,
                onRefresh: () async {
                  await controller.onReload();
                },
                child: ListView(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: placeholder(),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[200],
                child: Image.asset(
                  'assets/doctor.png',
                  fit: BoxFit.cover,
                ),
              ),
              Obx(
                () => Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: controller.homeVisitStatus.value != 0
                          ? Colors.green
                          : HVColors.alzarin,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Obx(
            () {
              return TextLbl().label(
                data: controller.namaUser.value.toUpperCase(),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.visible,
              );
            },
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              bottomSheetMenu();
            },
          ),
        ],
      ),
    );
  }

  placeholder() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            child: Image.asset(
              'assets/placeholder.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 25),
          TextLbl().label(
            data: 'Pesanan Belum Tersedia',
            textStyle: const TextStyle(fontSize: 14, color: HVColors.baseGrey),
          ),
        ],
      ),
    );
  }

  body() {
    return SizedBox(
      height: Layout.height,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: orderCard(),
          ),
          SizedBox(
            height: 3.h,
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding:
                  EdgeInsets.all(2.0.h), // Mengatur padding sesuai kebutuhan
              child: controller.statusOrder.value == 'Pemeriksaan Dokter'
                  ? buttonVerification()
                  : controller.statusOrder.value == 'Menunggu Dokter Approval'
                      ? Container()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            controller.statusOrder.value == 'Perjalanan Dokter'
                                ? buttonGetLoction()
                                : Container(),
                            buttonSlide(),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }

  orderCard() {
    return Card(
      color: Colors.white,
      borderOnForeground: true,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextLbl().label(
              data: 'Pesanan',
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            TextLbl().label(
              data: 'Nama Pemesan',
              textStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            TextLbl().label(
              data: '${controller.listOrder[0].namaPemesan}'.capitalizes(),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextBtn().button(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  textStyle: const TextStyle(color: Colors.white),
                  backgroundColor: HVColors.primary,
                  onPressed: () {
                    controller.getApprove();
                    if (controller.statusOrder.value ==
                        'Menunggu Dokter Approval') {
                      controller.getApprove();
                    } else {
                      Get.toNamed(utility.RouteName.detailOrder, arguments: {
                        'order_model': controller.listOrder,
                      });
                    }
                  },
                  label:
                      controller.statusOrder.value == 'Menunggu Dokter Approval'
                          ? 'Terima Pesanan'
                          : 'Detail Pesanan'),
            ),
          ],
        ),
      ),
    );
  }

  bottomSheetMenu() {
    return Get.bottomSheet(
      ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        child: Container(
          height: 18.h,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
                  child: const Text(
                    'Apakah anda yakin untuk keluar?',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
                  child: buttonConfirmationLogout(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buttonConfirmationLogout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextBtn().button(
            onPressed: () => controller.logout(),
            borderRadius: const BorderRadius.all(
              Radius.circular(100),
            ),
            label: "Ya, Keluar",
            backgroundColor: HVColors.primary,
            textStyle: TextStyle(fontSize: 12.sp, color: Colors.white),
          ),
        ),
        SizedBox(
          width: 2.h,
        ),
        Expanded(
          child: TextBtn().button(
              onPressed: () => Get.back(),
              label: "Tidak",
              textStyle: TextStyle(fontSize: 12.sp, color: Colors.black45)),
        ),
      ],
    );
  }

  buttonSlide() {
    return Center(
      child: ActionSlider.standard(
        boxShadow: const [],
        action: (c) async {
          try {
            if (controller.statusOrder.value == 'Dokter Approval') {
              await controller.getPrepare();
            } else if (controller.statusOrder.value == 'Persiapan Dokter') {
              await controller.getOnGoing();
            } else if (controller.statusOrder.value == 'Perjalanan Dokter') {
              await controller.getVerification();
            }
          } catch (e) {
            Exception(e.toString());
          }
        },
        height: 60,
        toggleColor: HVColors.primary,
        backgroundColor: HVColors.secondary,
        sliderBehavior: SliderBehavior.stretch, // Menambahkan efek stretch
        icon: const Icon(
          Icons.chevron_right_sharp,
          color: Colors.white,
        ),
        successIcon:
            const Icon(Icons.check, color: Colors.white), // Ikon saat sukses
        failureIcon: const Icon(Icons.close, color: Colors.white),
        child: controller.statusOrder.value == 'Dokter Approval'
            ? const Text(
                'geser untuk persiapan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              )
            : controller.statusOrder.value == 'Persiapan Dokter'
                ? const Text(
                    'geser untuk perjalanan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : controller.statusOrder.value == 'Perjalanan Dokter'
                    ? const Text(
                        'geser untuk memeriksa',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Container(),
      ),
    );
  }

  buttonVerification() {
    return SizedBox(
      width: double.infinity,
      child: TextBtn().button(
        onPressed: () {
          controller.box.write('uuid', controller.listOrder[0].uuid);
          Get.offAndToNamed(utility.RouteName.cameraForm);
        },
        backgroundColor: HVColors.primary,
        textStyle: const TextStyle(color: Colors.white),
        label: 'Input data pasien',
      ),
    );
  }

  buttonGetLoction() {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: SizedBox(
        width: double.infinity,
        child: TextBtn().button(
          onPressed: () {
            openGoogleMaps(
              latitude: controller.listOrder[0].orderLatitudeTarget,
              longitude: controller.listOrder[0].orderLongitudeTarget,
            );
          },
          label: 'Menuju ke lokasi',
          textStyle: const TextStyle(color: HVColors.primary),
          backgroundColor: HVColors.primaryLite,
        ),
      ),
    );
  }
}
