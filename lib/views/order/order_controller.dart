import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_visit/model/order_model.dart';
import 'package:home_visit/services/base_controller.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import '../../model/diagnosis_model.dart';
import '../../model/obat_model.dart';
import '../../services/api_services.dart';
import '../../services/base_client.dart';

import '/routes/route_name.dart' as utility;

class OrderController extends GetxController with BaseController {
  GetStorage box = GetStorage();
  String clientId = '3';
  String clientSecret = 'UuTlanKjhT7FKtig5RY2Cq2crJjYpVWqZNbQbiij';
  var isLoading = false.obs;
  var token = ''.obs;
  var uuid = ''.obs;
  var patientOrders = <Pasiens>[].obs;
  var obatList = <ObatModel>[].obs;
  var selectedMedicines = Rxn<ObatModel>();
  var listOrder = <OrderModel>[].obs;
  var filteredObatList = <ObatModel>[].obs;
  //dropdown visibility per patient
  var showDropdownForPatient = <int, bool>{}.obs;

  //selected medicines per patient
  var patientSelectedMedicines = <int, List<SelectedMedicine>>{}.obs;

  // var selectedTags = <DiagnosisTagModel>[].obs;
  RxMap<int?, List<DiagnosisTagModel>> selectedDiagnosisMap =
      <int?, List<DiagnosisTagModel>>{}.obs;

  final SearchableDropdownController<ObatModel> dropdownController =
      SearchableDropdownController<ObatModel>();

  late TextEditingController searchTextController;
  late TextEditingController jumlahController;
  late TextEditingController aturanPakaiController;
  late TextEditingController keteranganController;

  final FocusNode focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    searchTextController = TextEditingController(text: '');
    jumlahController = TextEditingController(text: '');
    aturanPakaiController = TextEditingController(text: '');
    keteranganController = TextEditingController(text: '');
    token.value = box.read('auth_token');
    fetchListOrder();
    fetchListPasien();
    // loadDiagnosisFromStorage();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    jumlahController.dispose();
    aturanPakaiController.dispose();
    keteranganController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void removeFocus() {
    focusNode.unfocus();
  }

  Future<List<Pasiens>?> getListPasien() async {
    var response = await BaseClient().get(
        ApiEndPoint.baseUrl,
        ApiEndPoint.authEndPoints.aktif,
        {'Authorization': 'Bearer ${token.value}'}).catchError(handleError);

    var responData = json.decode(response);

    if (response != null) {
      // Ubah ini menjadi tidak null
      List<dynamic> arr = responData['data'];
      List<Pasiens> result = [];

      for (var order in arr) {
        List<dynamic> pasiensList = order['pasiens'];
        for (var pasienData in pasiensList) {
          result.add(
              Pasiens.fromJson(pasienData)); // Menambahkan pasien satu per satu
        }
      }

      return result;
    } else {
      return null;
    }
  }

  Future<void> fetchListPasien() async {
    isLoading.value = true;
    try {
      var list = await getListPasien();
      if (list != null) {
        patientOrders.assignAll(list);
        update();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void addTag(int patientIndex, DiagnosisTagModel selectedTag) {
    var patientId = patientOrders[patientIndex].id;
    if (patientId == null) {
      // print("Error: Patient ID is null for index $patientIndex");
      return;
    }

    var tags = selectedDiagnosisMap[patientId] ?? [];
    if (!tags.any((tag) => tag.id == selectedTag.id)) {
      tags.add(selectedTag);
      selectedDiagnosisMap[patientId] = tags;
      // saveDiagnosisToStorage();
      update();
      // print(
      //     "Added tag ${selectedTag.nmDiag} to patient $patientId, tags now: ${tags.map((e) => e.nmDiag)}");
    }
  }

  void removeTag(int patientId, DiagnosisTagModel tagToRemove) {
    var tags = selectedDiagnosisMap[patientId] ?? [];
    tags.removeWhere((tag) => tag.id == tagToRemove.id);
    selectedDiagnosisMap[patientId] =
        tags; // This is just re-assigning the modified list back to the map

    // saveDiagnosisToStorage();
    update(); // Trigger UI update
  }

  // void saveDiagnosisToStorage() {
  //   final data = selectedDiagnosisMap.map((key, value) => MapEntry(
  //         key.toString(),
  //         value.map((e) => e.toJson()).toList(),
  //       ));
  //   box.write('diagnosisData', data);
  // }

  // void loadDiagnosisFromStorage() {
  //   final data = box.read<Map<String, dynamic>>('diagnosisData') ?? {};
  //   selectedDiagnosisMap.clear();
  //   data.forEach((key, value) {
  //     selectedDiagnosisMap[int.parse(key)] =
  //         (value as List).map((e) => DiagnosisTagModel.fromJson(e)).toList();
  //   });
  //   update();
  // }

  //obat
  // Function to add selected medicine to a patient

  void addMedicineToPatient(int patientId, ObatModel obat, int? jumlah,
      String aturanPakai, String keterangan) {
    // Validasi jika jumlah, aturan pakai, atau keterangan tidak diisi
    if (jumlah == null || jumlah <= 0) {
      Get.snackbar('Maaf', 'Jumlah obat wajib diisi dan harus lebih dari 0');
      return;
    }

    if (aturanPakai.isEmpty) {
      Get.snackbar('Maaf', 'Aturan pakai wajib diisi');
      return;
    }

    if (keterangan.isEmpty) {
      Get.snackbar('Maaf', 'Keterangan wajib diisi');
      return;
    }

    // Jika validasi lolos, lanjutkan proses penambahan obat ke pasien
    if (patientSelectedMedicines[patientId] == null) {
      patientSelectedMedicines[patientId] = [];
    }

    if (!patientSelectedMedicines[patientId]!
        .any((medicine) => medicine.obat!.id == obat.id)) {
      patientSelectedMedicines[patientId]!.add(
        SelectedMedicine(
          obat: obat,
          jumlah: jumlah,
          aturanPakai: aturanPakai,
          keterangan: keterangan,
        ),
      );

      // Clear fields setelah obat ditambahkan
      selectedMedicines.value = null;
      showDropdownForPatient[patientId] = false; // Hide dropdown after adding
      jumlahController.clear();
      aturanPakaiController.clear();
      keteranganController.clear();
      patientSelectedMedicines[patientId] =
          List.from(patientSelectedMedicines[patientId]!);
    } else {
      Get.snackbar('Maaf', 'Obat sudah ada untuk pasien ini');
    }
  }

  // Function to remove selected medicine from patient
  void removeMedicineFromPatient(int patientId, ObatModel obat) {
    patientSelectedMedicines[patientId]
        ?.removeWhere((medicine) => medicine.obat!.id == obat.id);
    patientSelectedMedicines[patientId] =
        List.from(patientSelectedMedicines[patientId]!);
  }

  // Menambah input obat baru
  void selectObat(ObatModel? obat) {
    selectedMedicines.value = obat;
    removeFocus();
  }

  // Function to show dropdown for a specific patient
  void showDropdown(int patientId) {
    if (showDropdownForPatient[patientId] == null) {
      showDropdownForPatient[patientId] = false;
    }
    showDropdownForPatient[patientId] = !showDropdownForPatient[patientId]!;
  }

  //API
  Future<List<DiagnosisTagModel>?> getDiagnosis(
      int patientIndex, String search) async {
    var response = await BaseClient().get(
        ApiEndPoint.baseUrl,
        '${ApiEndPoint.authEndPoints.diagnosis}?search=$search',
        {'Authorization': 'Bearer ${token.value}'}).catchError(handleError);

    var responseData = json.decode(response);

    if (responseData['status'] == 'Success') {
      List<dynamic> arr = responseData["data"]["data"];
      List<DiagnosisTagModel> result =
          arr.map((x) => DiagnosisTagModel.fromJson(x)).toList();
      return result;
    } else {
      return null;
    }
  }

  Future<List<SearchableDropdownMenuItem<ObatModel>>> fetchObatList(
      int page, String? searchKey) async {
    try {
      // isLoading.value = true;
      var response = await BaseClient().get(ApiEndPoint.ariMedicine,
          '${ApiEndPoint.authEndPoints.listMedicine}?page=$page&q=$searchKey', {
        'Client-Id': clientId,
        'Client-Secret': clientSecret,
      }).catchError(handleError);

      if (response == null) {
        Get.snackbar(
          'Maaf',
          'Data obat gagal didapat',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
      }

      final data = jsonDecode(response);

      if (data['status'] == true) {
        List<dynamic> obatData = data['data']['data'];
        List<SearchableDropdownMenuItem<ObatModel>> obatList =
            obatData.map((json) {
          var obat = ObatModel.fromJson(json);
          return SearchableDropdownMenuItem<ObatModel>(
            value: obat,
            label: '${obat.name}',
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text('${obat.name}'),
            ),
          );
        }).toList();
        return obatList;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      // isLoading.value = false; // Set loading ke false setelah selesai memuat
    }
    return [];
  }

//order list
  Future<List<OrderModel>?> getListOrder() async {
    var response = await BaseClient().get(
        ApiEndPoint.baseUrl,
        ApiEndPoint.authEndPoints.aktif,
        {'Authorization': 'Bearer ${token.value}'}).catchError(handleError);

    var responData = json.decode(response);

    if (response = true) {
      List<dynamic> arr = responData["data"];
      List<OrderModel> result = [];
      // ignore: avoid_function_literals_in_foreach_calls
      arr.forEach(
        (x) {
          result.add(OrderModel.fromJson(x));
        },
      );
      return result;
    } else {
      return null;
    }
  }

  Future<void> fetchListOrder() async {
    isLoading.value = true;
    try {
      var list = await getListOrder();
      if (list != null && list.isNotEmpty) {
        listOrder.assignAll(list);
        uuid.value = '${listOrder[0].uuid}';
      } else {
        return;
        // Handle the case where the list is null or empty
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Mengirim data ke API

  Future<void> submitOrderToApi() async {
    showLoading();
    Map<String, dynamic> payload = {
      "pasiens": patientOrders.map((patient) {
        var diagnoses = selectedDiagnosisMap[patient.id]
                ?.map((tag) => {
                      'uuid': tag.uuid,
                      'kdDiag': tag.kdDiag,
                      'nmDiag': tag.nmDiag,
                    })
                .toList() ??
            [];

        var medicines = patientSelectedMedicines[patient.id]
                ?.map((SelectedMedicine medicine) => {
                      'obat_id': medicine.obat!.id,
                      'obat_text': medicine.obat!.name,
                      'jumlah': medicine.jumlah,
                      'satuan': medicine.obat!.unit,
                      'Price': medicine.obat!.price,
                      'aturan_pakai': medicine.aturanPakai,
                      'keterangan': medicine.keterangan,
                    })
                .toList() ??
            [];

        return {
          'id': patient.id,
          'pasien_id': patient.pasienId,
          'policy_no': patient.policyNo,
          'member_id': patient.memberId,
          'nama': patient.nama,
          'tgl_lahir': patient.tglLahir,
          'gender': patient.gender,
          'email': patient.email,
          'phone': patient.phone,
          'berat_badan': patient.beratBadan,
          'tinggi_badan': patient.tinggiBadan,
          'alergi': patient.alergi,
          'keluhan': patient.keluhan,
          'diagnosa': diagnoses,
          'obat': medicines,
        };
      }).toList()
    };

    // Validasi: Cek apakah semua pasien memiliki diagnosis
    bool allPatientsHaveDiagnoses = payload["pasiens"]!.every((patient) {
      var diagnosaList = patient['diagnosa'] as List<dynamic>;
      return diagnosaList.isNotEmpty;
    });

    if (!allPatientsHaveDiagnoses) {
      hideLoading();
      Get.snackbar('Peringatan', 'Diagnosis wajib diisi untuk setiap pasien.');
      return;
    }

    try {
      var jsonPayload = jsonEncode(payload);
      // print(jsonPayload);

      var response = await BaseClient()
          .post(
            ApiEndPoint.baseUrl,
            '${ApiEndPoint.authEndPoints.inputRekamMedis}/${uuid.value}',
            {
              'Authorization': 'Bearer ${token.value}',
              'Content-Type': 'application/json',
            }, // Header request
            jsonPayload, // Payload sebagai JSON String
          )
          .catchError(handleError);

      final responseData = jsonDecode(response);
      hideLoading();
      if (responseData['status'] == 'Success') {
        Get.back();
        await Get.offAndToNamed(utility.RouteName.orderDone);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {}
    return;
  }

  // Implementasi pengiriman data menggunakan HTTP POST
  // var response = await http.post(
  //   Uri.parse('URL_API'),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //   },
  //   body: jsonEncode(orderData),
  // );

  // if (response.statusCode == 200) {
  //   // Handle response
  //   print('Data submitted successfully');
  // } else {
  //   // Handle error
  //   throw Exception('Failed to submit data: ${response.body}');
  // }
}
