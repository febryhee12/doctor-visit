import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_visit/services/base_controller.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../controller/camera_permission.dart';
import '../../model/order_model.dart';
import '../../services/api_services.dart';
import '../../services/base_client.dart';

import '/routes/route_name.dart' as utility;

class CameraFormController extends GetxController with BaseController {
  GetStorage box = GetStorage();
  final picker = ImagePicker();
  var token = ''.obs;
  var patientOrders = <Pasiens>[].obs;

  @override
  void onInit() {
    super.onInit();
    token.value = box.read('auth_token');
    requestCameraPermission();
    fetchListPasien();
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
    try {
      var list = await getListPasien();
      if (list != null) {
        patientOrders.assignAll(
            list); // Pastikan ini benar-benar mendapatkan semua pasien
      }
    } finally {}
  }

  // Pick image from camera

  Future<void> pickImageFromCamera(int index) async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      // Konversi XFile menjadi File
      File imageFile = File(pickedFile.path);
      box.write('image_$index', pickedFile.path);

      // Tambahkan gambar ke patientOrders[index].images
      patientOrders[index].images.add(ImageModel(
            id: null, // id bisa diisi setelah upload berhasil jika diperlukan
            homeVisitOrderId: patientOrders[index].homeVisitOrderId,
            homeVisitOrderPasienId: patientOrders[index].id,
            image: imageFile.path, // Simpan path gambar
            createdAt: DateTime.now().toIso8601String(),
            updatedAt: DateTime.now().toIso8601String(),
          ));

      String uuid = box.read('uuid');
      String token = box.read('auth_token');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          '${ApiEndPoint.baseUrl + ApiEndPoint.authEndPoints.uploadDocument}/$uuid',
        ),
      );

      // Tambahkan gambar sebagai MultipartFile
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'), // Sesuaikan format
        ),
      );

      // Tambahkan field tambahan
      request.fields['home_visit_order_pasien_id'] =
          '${patientOrders[index].id!}';

      // Tambahkan header Authorization
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      // Kirim request ke API
      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          // print('Request berhasil');
        } else {
          // print('Error: ${response.statusCode}');
        }
      } catch (e) {
        // print('Exception caught: $e');
      }
    }
  }

  String? getImagePath(int index) {
    return box.read('image_$index'); // Ambil path berdasarkan index
  }

  void removeAllImages() {
    final keys =
        box.getKeys().where((key) => key.startsWith('image_')).toList();
    for (var key in keys) {
      String? imagePath = box.read(key);
      if (imagePath != null) {
        final file = File(imagePath);
        if (file.existsSync()) {
          file.deleteSync(); // Hapus file dari storage
        }
      }
      box.remove(key); // Hapus path dari GetStorage
    }
    update(); // Refresh state
  }

// Fungsi untuk validasi sebelum submit
  void validateAndSubmit() {
    bool hasAllImages = true;

    // Cek apakah setiap pasien sudah memiliki minimal satu gambar
    for (var patient in patientOrders) {
      if (patient.images.isEmpty) {
        hasAllImages = false;
        break;
      }
    }

    if (hasAllImages) {
      // Jika semua pasien memiliki gambar, pindah ke halaman berikutnya
      Get.toNamed(utility.RouteName.order);
    } else {
      // Tampilkan notifikasi jika ada pasien tanpa gambar
      Get.snackbar('Maaf', 'Pastikan data pasien sudah diupload');
    }
  }
}
