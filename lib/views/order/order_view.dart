import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:home_visit/model/diagnosis_model.dart';
import 'package:home_visit/styles/color.dart';
import 'package:home_visit/views/order/order_controller.dart';
import 'package:home_visit/widgets/text_lbl.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:sizer/sizer.dart';
import '../../model/obat_model.dart';
import '../../model/order_model.dart';
import '../../styles/layout.dart';
import '../../widgets/form_field.dart';
import '../../widgets/text_btn.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: HVColors.flashWhite,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            'Input Rekam Medis',
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: Obx(
          () {
            if (controller.isLoading.value == true) {
              return const Center(
                child: CircularProgressIndicator(
                  color: HVColors.primary,
                ),
              );
            } else {
              return body(context);
            }
          },
        ),
      ),
    );
  }

  body(context) {
    return Obx(
      () {
        final bool isKeyboardVisible =
            MediaQuery.of(context).viewInsets.bottom != 0;

        return Stack(
          children: [
            ListView.builder(
              padding: EdgeInsets.only(top: 1.h),
              itemCount: controller.patientOrders.length,
              itemBuilder: (context, patientIndex) {
                final patient = controller.patientOrders[patientIndex];

                return Padding(
                  padding: patientIndex == controller.patientOrders.length - 1
                      ? EdgeInsets.fromLTRB(1.h, 0.h, 1.h, 12.h)
                      : EdgeInsets.fromLTRB(1.h, 0.h, 1.h, 1.h),
                  child: Card(
                    color: Colors.white,
                    elevation: 0,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.h, vertical: 2.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextLbl().label(
                                overflow: TextOverflow.ellipsis,
                                data: '${patient.nama}'.toUpperCase(),
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                              TextButton(
                                onPressed: () => bottomSheetDetail(patient),
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(50, 30),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    alignment: Alignment.centerLeft),
                                child: Text(
                                  'DETAIL',
                                  style: TextStyle(
                                      fontSize: 11.sp, color: HVColors.primary),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          // Input tag (penambahan di bawah diagnosa)
                          diagnosa(patientIndex, context),
                          //diagnosa
                          SizedBox(
                            height: 3.h,
                          ),
                          //obat
                          Center(
                            child: SizedBox(
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.showDropdown(
                                      patient.id!); // Show dropdown
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: HVColors.primary,
                                ),
                                child: Obx(() => Text(
                                      style:
                                          const TextStyle(color: Colors.white),
                                      controller.showDropdownForPatient[
                                                  patient.id!] ==
                                              true
                                          ? 'Sembunyikan'
                                          : 'Tambah Obat',
                                    )),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Obx(() {
                            if (controller.showDropdownForPatient[patient.id] ==
                                true) {
                              return Column(
                                children: [
                                  SearchableDropdown<ObatModel>.paginated(
                                    paginatedRequest: controller.fetchObatList,
                                    requestItemCount:
                                        10, // jumlah item per page
                                    hintText: const Text('Cari Obat...'),
                                    searchHintText: 'Ketik untuk mencari obat',
                                    onChanged: (ObatModel? obat) {
                                      controller.selectObat(obat);
                                    },
                                    initialValue: controller
                                                .selectedMedicines.value !=
                                            null
                                        ? SearchableDropdownMenuItem<ObatModel>(
                                            value: controller
                                                .selectedMedicines.value!,
                                            label:
                                                '${controller.selectedMedicines.value!.name}',
                                            child: Text(
                                                '${controller.selectedMedicines.value!.name}'),
                                          )
                                        : null,
                                    noRecordText:
                                        const Text('Data tidak tersedia'),
                                  ),
                                  const SizedBox(height: 10),
                                  fieldMedicineCount(),
                                  const SizedBox(height: 10),
                                  fieldMedicineHowToUse(),
                                  const SizedBox(height: 10),
                                  fieldMedicineDescription(),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: controller
                                                .selectedMedicines.value ==
                                            null
                                        ? null // Disable button if no medicine is selected
                                        : () {
                                            controller.addMedicineToPatient(
                                              patient.id!,
                                              controller
                                                  .selectedMedicines.value!,
                                              int.parse(controller
                                                  .jumlahController.text),
                                              controller
                                                  .aturanPakaiController.text,
                                              controller
                                                  .keteranganController.text,
                                            );
                                          },
                                    child: Text(
                                      'Simpan Obat',
                                      style: TextStyle(
                                          color: controller.selectedMedicines
                                                      .value ==
                                                  null
                                              ? Colors.grey
                                              : Colors.black87),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            } else {
                              return const SizedBox
                                  .shrink(); // Hide dropdown if not clicked
                            }
                          }),
                          Obx(() {
                            final medicines = controller
                                    .patientSelectedMedicines[patient.id] ??
                                [];
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: medicines.length,
                              itemBuilder: (context, index) {
                                final SelectedMedicine medicine =
                                    medicines[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          width: 1, color: HVColors.greybg)),
                                  child: ListTile(
                                    title: Text(
                                      medicine.obat!.name!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: HVColors.primary),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 0.5.h),
                                        Text('Jumlah: ${medicine.jumlah}'),
                                        SizedBox(height: 0.5.h),
                                        Text(
                                            'Aturan Pakai: ${medicine.aturanPakai}'),
                                        SizedBox(height: 0.5.h),
                                        Text(
                                            'Keterangan: ${medicine.keterangan}'),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      iconSize: 24,
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: HVColors.alzarin,
                                      ),
                                      onPressed: () {
                                        controller.removeMedicineFromPatient(
                                            patient.id!, medicine.obat!);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 1.5.h,
            ),
            if (!isKeyboardVisible) // Only show when keyboard is not visible
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.all(2.h),
                  decoration: const BoxDecoration(color: HVColors.flashWhite),
                  child: buttonSubmit(),
                ),
              ),
          ],
        );
      },
    );
  }

  diagnosa(patientIndex, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TypeAheadField<DiagnosisTagModel>(
          builder: (context, textcontroller, focusNode) {
            return CustomFormField().field(
              question: "Input Diagnosa",
              controller: textcontroller,
              focusNode: focusNode,
              canBeNull: false,
              obscureText: false,
              keyboardType: TextInputType.text,
            );
          },
          suggestionsCallback: (pattern) async {
            if (pattern.isEmpty) {
              return [];
            }
            var diagnosisList =
                await controller.getDiagnosis(patientIndex, pattern);

            return diagnosisList
                    ?.where((tag) => !(controller
                            .selectedDiagnosisMap[patientIndex]
                            ?.any((selected) => selected.id == tag.id) ??
                        false))
                    .toList() ??
                [];
          },
          itemBuilder: (context, DiagnosisTagModel suggestion) {
            return ListTile(title: Text(suggestion.nmDiag!));
          },
          onSelected: (DiagnosisTagModel selectedTag) {
            FocusScope.of(context).unfocus();
            controller.addTag(patientIndex, selectedTag);

            Future.delayed(const Duration(milliseconds: 100), () {
              FocusScope.of(context).requestFocus(FocusNode());
            });
          },
          emptyBuilder: (context) => const ListTile(
            title: Text('Data tidak ditemukan'),
          ),
          hideOnLoading: true,
          hideWithKeyboard: true,
        ),
        const SizedBox(height: 10),
        Obx(
          () => Wrap(
            children: controller.selectedDiagnosisMap[
                        controller.patientOrders[patientIndex].id]
                    ?.map((tag) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Chip(
                      label: Text(tag.nmDiag!),
                      onDeleted: () {
                        controller.removeTag(
                            controller.patientOrders[patientIndex].id!, tag);
                      },
                    ),
                  );
                }).toList() ??
                [],
          ),
        )
      ],
    );
  }

  buttonSubmit() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: TextBtn().button(
        onPressed: () {
          bottomSheetMenu();
        },
        backgroundColor: HVColors.primary,
        textStyle: const TextStyle(color: Colors.white),
        label: 'Submit',
      ),
    );
  }

  bottomSheetMenu() {
    return Get.bottomSheet(
      Wrap(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              color: Colors.white,
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          right: 2.h, left: 2.h, top: 2.h, bottom: 2.5.h),
                      child: const Text(
                        'Apakah anda yakin data rekam medis yang telah diisi sudah benar dan lengkap?\n\nSetelah disimpan, data ini tidak dapat diubah.',
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
          ),
        ],
      ),
    );
  }

  buttonConfirmationLogout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextBtn().button(
            onPressed: () => controller.submitOrderToApi(),
            borderRadius: const BorderRadius.all(
              Radius.circular(100),
            ),
            label: "Saya, sudah yakin",
            backgroundColor: HVColors.primary,
            textStyle: const TextStyle(color: Colors.white),
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
              textStyle: const TextStyle(color: Colors.black87)),
        ),
      ],
    );
  }

  fieldMedicineCount() {
    return CustomFormField().field(
      question: "Jumlah",
      canBeNull: false,
      obscureText: false,
      controller: controller.jumlahController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        FilteringTextInputFormatter.deny(RegExp('[_ ]')),
      ],
    );
  }

  fieldMedicineHowToUse() {
    return CustomFormField().field(
      question: "Aturan Pakai",
      canBeNull: false,
      obscureText: false,
      controller: controller.aturanPakaiController,
      keyboardType: TextInputType.text,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
        FilteringTextInputFormatter.deny(RegExp('[_]')),
      ],
    );
  }

  fieldMedicineDescription() {
    return CustomFormField().field(
      question: "Keterangan",
      canBeNull: false,
      obscureText: false,
      controller: controller.keteranganController,
      keyboardType: TextInputType.text,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
        FilteringTextInputFormatter.deny(RegExp('[_]')),
      ],
    );
  }

  bottomSheetDetail(Pasiens patien) {
    return Get.bottomSheet(
      Wrap(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            child: Container(
              width: Layout.width,
              padding: EdgeInsets.all(2.h),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        width: 50,
                        height: 5,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  desc(
                      label: 'Nama Pasien',
                      desc: '${patien.nama}'.toUpperCase()),
                  SizedBox(height: 1.5.h),
                  desc(label: 'Tanggal Lahir', desc: '${patien.tglLahir}'),
                  SizedBox(height: 1.5.h),
                  desc(label: 'Gender', desc: '${patien.gender}'),
                  SizedBox(height: 1.5.h),
                  desc(label: 'Berat Badan', desc: '${patien.beratBadan} KG'),
                  SizedBox(height: 1.5.h),
                  desc(label: 'Tinggi Badan', desc: '${patien.tinggiBadan} CM'),
                  SizedBox(height: 2.h),
                  desc2(label: 'Alergi', desc: '${patien.alergi}'),
                  SizedBox(height: 2.h),
                  desc2(label: 'Keluhan', desc: '${patien.keluhan}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget desc({required String label, required String desc}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextLbl().label(
          overflow: TextOverflow.ellipsis,
          data: label,
          textStyle: const TextStyle(color: Colors.black54),
        ),
        TextLbl().label(
          overflow: TextOverflow.ellipsis,
          data: desc,
          textStyle: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
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
