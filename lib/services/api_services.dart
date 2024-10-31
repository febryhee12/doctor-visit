class ApiEndPoint {
  static const String baseUrl =
      'https://staging.isoclinic.co.id/api/homevisit/dokter/'; //staging
  // 'https://isoclinic.co.id/api/homevisit/dokter/'; //live
  // ignore: library_private_types_in_public_api
  static const String clinicUrl =
      'https://staging.isoclinic.co.id/api/homevisit/'; //staging
  // 'https://isoclinic.co.id/api/homevisit/'; //live
  static const String ariMedicine = 'https://app.vivamedika.co.id/api/ari/';
  // ignore: library_private_types_in_public_api
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String auth = 'login';
  final String profile = 'profil';
  final String diagnosis = 'diagnosis';
  final String aktif = 'order/aktif';
  final String approve = 'order/approve';
  final String persiapan = 'order/persiapan';
  final String perjalanan = 'order/perjalanan';
  final String pemerikasaan = 'order/memeriksa';
  final String inputRekamMedis = 'order/input_rekam_medis_pasien';
  final String uploadDocument = 'kirim_foto';
  final String currentLocation = 'lokasi_terbaru';
  final String storeToken = 'store_token';
  final String cekOrder = 'order';

  final String listMedicine = 'list-medicine';
}
