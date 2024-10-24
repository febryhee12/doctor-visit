import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_visit/views/detail_order/detail_order_controller.dart';
import 'package:home_visit/widgets/text_lbl.dart';
import 'package:sizer/sizer.dart';

class DetailOrderView extends GetView<DetailOrderController> {
  const DetailOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Detail Order'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 2.h, top: 2.h),
              child: TextLbl().label(
                overflow: TextOverflow.ellipsis,
                data: 'Data Pemesan'.toUpperCase(),
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                borderOnForeground: true,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.h),
                      child: TextLbl().label(
                        data: 'Nama Pemesan',
                        textStyle: const TextStyle(color: Colors.black54),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.h),
                      child: TextLbl().label(
                        data: '${controller.listOrder[0].namaPemesan}',
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.h),
                      child: TextLbl().label(
                        data: '${controller.listOrder[0].phone}',
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const Divider(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextLbl().label(
                                  data: 'Waktu',
                                  textStyle:
                                      const TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 3),
                                Obx(
                                  () {
                                    return TextLbl().label(
                                      data: controller.getTime(),
                                      textStyle: const TextStyle(fontSize: 14),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextLbl().label(
                                  data: 'Tanggal',
                                  textStyle:
                                      const TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 3),
                                Obx(
                                  () {
                                    return TextLbl().label(
                                      data: controller.getFormattedDate(),
                                      textStyle: const TextStyle(fontSize: 14),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.h),
                      child: TextLbl().label(
                        data: 'Lokasi',
                        textStyle: const TextStyle(color: Colors.black54),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.h),
                      child: TextLbl().label(
                        data: '${controller.listOrder[0].alamat}',
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 2.h, top: 2.h),
              child: TextLbl().label(
                overflow: TextOverflow.ellipsis,
                data: 'Data Pasien'.toUpperCase(),
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 1.h),
              itemCount: controller.listOrder[0].pasiens!.length,
              itemBuilder: (context, patientIndex) {
                final patient = controller.listOrder[0].pasiens![patientIndex];

                return Padding(
                  padding: patientIndex == controller.patientOrders.length - 1
                      ? EdgeInsets.fromLTRB(1.h, 0.h, 1.h, 12.h)
                      : EdgeInsets.fromLTRB(1.h, 0.h, 1.h, 1.h),
                  child: Card(
                    borderOnForeground: true,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 1.h),
                          desc(
                              label: 'Nama Pasien',
                              desc: '${patient.nama}'.toUpperCase()),
                          SizedBox(height: 1.h),
                          desc(
                              label: 'Tanggal Lahir',
                              desc: '${patient.tglLahir}'),
                          SizedBox(height: 1.h),
                          desc(label: 'Gender', desc: '${patient.gender}'),
                          SizedBox(height: 1.h),
                          desc(
                              label: 'Berat Badan',
                              desc: '${patient.beratBadan} KG'),
                          SizedBox(height: 1.h),
                          desc(
                              label: 'Tinggi Badan',
                              desc: '${patient.tinggiBadan} CM'),
                          SizedBox(height: 2.h),
                          desc2(label: 'Alergi', desc: '${patient.alergi}'),
                          SizedBox(height: 2.h),
                          desc2(label: 'Keluhan', desc: '${patient.keluhan}'),
                          SizedBox(height: 1.h),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget desc({required String label, required String desc}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextLbl().label(
          overflow: TextOverflow.ellipsis,
          data: label,
          textStyle: const TextStyle(color: Colors.black54),
        ),
        Flexible(
          child: TextLbl().label(
            data: desc,
            textStyle: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        )
      ],
    );
  }

  Widget desc2({required String label, required String desc}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextLbl().label(
          overflow: TextOverflow.ellipsis,
          data: label,
          textStyle: const TextStyle(color: Colors.black54),
        ),
        Flexible(
          child: TextLbl().label(
            data: desc,
            textStyle: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        )
      ],
    );
  }
}
