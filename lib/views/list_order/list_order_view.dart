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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Avatar
            CircleAvatar(
              child: Image.asset(
                'assets/doctor.png',
              ),
            ),
            const SizedBox(width: 15),
            // Nama User
            Obx(
              () {
                return Expanded(
                  child: TextLbl().label(
                    data: controller.namaUser.value.capitalizes(),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    // Memberikan batasan maksimal pada lebar teks
                    overflow: TextOverflow.ellipsis,
                  ),
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
      ),
      body: Obx(
        () {
          if (controller.isLoading.value == true) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (controller.listOrder.isNotEmpty) {
            return body();
          } else {
            return RefreshIndicator(
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
                  placeholder(),
                  SizedBox(
                    height: 5.h,
                  ),
                  // Center(child: Text('token FCM')),
                  // Center(
                  //   child: Padding(
                  //     padding: EdgeInsets.all(8.0),
                  //     child: GestureDetector(
                  //         onTap: () {
                  //           controller.copyTokenToClipboard();
                  //         },
                  //         child: Text(controller.tokenfcm.value)),
                  //   ),
                  // ),
                ],
              ),
            );
          }
        },
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
          // Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       ElevatedButton(
          //         onPressed: () async {
          //           startBackgroundService();
          //         },
          //         child: const Text('Start Service'),
          //       ),
          //       const SizedBox(height: 16),
          //       ElevatedButton(
          //         onPressed: () async {
          //           stopBackgroundService();
          //         },
          //         child: const Text('Stop Service'),
          //       ),
          //     ],
          //   ),
          // ),
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
            child: Card(
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
                      data: 'Booking Order',
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
                      data: '${controller.listOrder[0].namaPemesan}'
                          .capitalizes(), // Menampilkan nama pemesan dari order pertama
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    // const SizedBox(height: 8),
                    // controller.timeAccept.value != ''
                    //     ? const SizedBox()
                    //     : Row(
                    //         children: [
                    //           const Icon(
                    //             Icons.access_time,
                    //             size: 16,
                    //             color: Colors.grey,
                    //           ),
                    //           const SizedBox(width: 5),
                    //           Text(
                    //             controller.timeLeft.value,
                    //             style: const TextStyle(
                    //               fontSize: 14,
                    //               color: Colors.black54,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            if (controller.statusOrder.value ==
                                'Menunggu Dokter Approval') {
                              controller.getApprove();
                            } else {
                              Get.toNamed(utility.RouteName.detailOrder,
                                  arguments: {
                                    'order_model': controller.listOrder,
                                  });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: controller.statusOrder.value ==
                                  'Menunggu Dokter Approval'
                              ? const Text(
                                  'Terima',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Lihat Detail',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Center(child: Text('token FCM')),
          // Center(
          //   child: Padding(
          //     padding: EdgeInsets.all(8.0),
          //     child: GestureDetector(
          //         onTap: () {
          //           controller.copyTokenToClipboard();
          //         },
          //         child: Text(controller.tokenfcm.value)),
          //   ),
          // ),
          SizedBox(
            height: 2.h,
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

  bottomSheetMenu() {
    return Get.bottomSheet(
      Container(
        height: 18.h,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: 2.h, left: 2.5.h, top: 2.h, bottom: 2.h),
                child: const Text(
                  'Apakah anda yakin untuk keluar?',
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.h),
                child: buttonConfirmationLogout(),
              ),
            ],
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
              borderRadius: const BorderRadius.all(
                Radius.circular(100),
              ),
              label: "Tidak",
              textStyle: TextStyle(fontSize: 12.sp, color: Colors.black87)),
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
            // Panggil fungsi getApprove() di sini
            if (controller.statusOrder.value == 'Dokter Approval') {
              await controller.getPrepare();
            } else if (controller.statusOrder.value == 'Persiapan Dokter') {
              await controller.getOnGoing();
            } else if (controller.statusOrder.value == 'Perjalanan Dokter') {
              await controller.getVerification();
            }
            // Jika berhasil, tampilkan status berhasil pada slider
            // c.success(); // Mengubah status slider ke sukses
          } catch (e) {
            // Jika gagal, tampilkan status gagal
            // c.failure(); // Mengubah status slider ke gagal
          }
        },
        toggleColor: HVColors.primary,
        backgroundColor: Colors.black26,
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
                'Geser untuk persiapan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            : controller.statusOrder.value == 'Persiapan Dokter'
                ? const Text(
                    'Geser untuk perjalanan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : controller.statusOrder.value == 'Perjalanan Dokter'
                    ? const Text(
                        'Geser untuk memeriksa',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
      child: ElevatedButton(
          onPressed: () {
            controller.box.write('uuid', controller.listOrder[0].uuid);
            Get.offAndToNamed(utility.RouteName.cameraForm);
            // print(controller.listOrder[0].pasiens![0].images[0].image);
            // if (controller.listOrder[0].pasiens![0].images.isNotEmpty) {
            //   // Jika ada gambar, navigasi ke halaman order
            //   Get.toNamed(utility.RouteName.order);
            // } else {
            //   // Jika tidak ada gambar, navigasi ke halaman cameraForm
            // }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Melakukan input data pasien',
            style: TextStyle(
              color: Colors.white,
            ),
          )),
    );
  }

  buttonGetLoction() {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              openGoogleMaps(
                latitude: controller.listOrder[0].orderLatitudeTarget,
                longitude: controller.listOrder[0].orderLongitudeTarget,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Menuju lokasi pasien',
              style: TextStyle(
                color: Colors.white,
              ),
            )),
      ),
    );
  }
}
