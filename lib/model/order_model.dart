import 'package:get/get.dart';
import 'package:home_visit/model/obat_model.dart';

import 'diagnosis_model.dart';

class OrderModel {
  int? id;
  String? uuid;
  int? groupKlinikId;
  int? klinikId;
  String? orderUserId;
  String? userReliId;
  String? orderLongitude;
  String? orderLatitude;
  String? orderLongitudeTarget;
  String? orderLatitudeTarget;
  String? dokterId;
  String? orderNumber;
  String? namaPemesan;
  String? gender;
  String? email;
  String? phone;
  String? alamat;
  String? cityCode;
  String? districtCode;
  String? status;
  String? datetimeStart;
  String? datetimeAccept;
  String? datetimeEnd;
  String? waktuKunjung;
  int? preferenceGender;
  int? otherLanguage;
  String? createdAt;
  String? updatedAt;
  List<Pasiens>? pasiens;

  OrderModel(
      {this.id,
      this.uuid,
      this.groupKlinikId,
      this.klinikId,
      this.orderUserId,
      this.userReliId,
      this.orderLongitude,
      this.orderLatitude,
      this.orderLongitudeTarget,
      this.orderLatitudeTarget,
      this.dokterId,
      this.orderNumber,
      this.namaPemesan,
      this.gender,
      this.email,
      this.phone,
      this.alamat,
      this.cityCode,
      this.districtCode,
      this.status,
      this.datetimeStart,
      this.datetimeAccept,
      this.datetimeEnd,
      this.waktuKunjung,
      this.preferenceGender,
      this.otherLanguage,
      this.pasiens});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    groupKlinikId = json['group_klinik_id'];
    klinikId = json['klinik_id'];
    orderUserId = json['order_user_id'];
    userReliId = json['user_reli_id'];
    orderLongitude = json['order_longitude'];
    orderLatitude = json['order_latitude'];
    orderLongitudeTarget = json['order_longitude_target'];
    orderLatitudeTarget = json['order_latitude_target'];
    dokterId = json['dokter_id'];
    orderNumber = json['order_number'];
    namaPemesan = json['nama_pemesan'];
    gender = json['gender'];
    email = json['email'];
    phone = json['phone'];
    alamat = json['alamat'];
    cityCode = json['city_code'];
    districtCode = json['district_code'];
    status = json['status'] == '0'
        ? 'Pencarian'
        : json['status'] == '1'
            ? 'Menunggu Dokter Approval'
            : json['status'] == '2'
                ? 'Dokter Approval'
                : json['status'] == '3'
                    ? 'Persiapan Dokter'
                    : json['status'] == '4'
                        ? 'Perjalanan Dokter'
                        : json['status'] == '5'
                            ? 'Pemeriksaan Dokter'
                            : json['status'] == '6'
                                ? 'Selesai'
                                : json['status'] == '7'
                                    ? 'Dibatalkan'
                                    : json['status'];
    datetimeStart = json['datetime_start'];
    datetimeAccept = json['datetime_accept'];
    datetimeEnd = json['datetime_end'];
    waktuKunjung = json['waktu_kunjung'];
    preferenceGender = json['preference_gender'];
    otherLanguage = json['other_language'];
    if (json['pasiens'] != null) {
      pasiens = <Pasiens>[];
      json['pasiens'].forEach((v) {
        pasiens!.add(Pasiens.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['group_klinik_id'] = groupKlinikId;
    data['klinik_id'] = klinikId;
    data['order_user_id'] = orderUserId;
    data['user_reli_id'] = userReliId;
    data['order_longitude'] = orderLongitude;
    data['order_latitude'] = orderLatitude;
    data['order_longitude_target'] = orderLongitudeTarget;
    data['order_latitude_target'] = orderLatitudeTarget;
    data['dokter_id'] = dokterId;
    data['order_number'] = orderNumber;
    data['nama_pemesan'] = namaPemesan;
    data['gender'] = gender;
    data['email'] = email;
    data['phone'] = phone;
    data['alamat'] = alamat;
    data['city_code'] = cityCode;
    data['district_code'] = districtCode;
    data['status'] = status;
    data['datetime_start'] = datetimeStart;
    data['datetime_accept'] = datetimeAccept;
    data['datetime_end'] = datetimeEnd;
    data['waktu_kunjung'] = waktuKunjung;
    data['preference_gender'] = preferenceGender;
    data['other_language'] = otherLanguage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pasiens != null) {
      data['pasiens'] = pasiens!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pasiens {
  int? id;
  int? homeVisitOrderId;
  String? pasienId;
  String? policyNo;
  String? memberId;
  String? nama;
  String? tglLahir;
  String? gender;
  String? email;
  String? phone;
  int? beratBadan;
  int? tinggiBadan;
  String? alergi;
  String? keluhan;
  RxList<ImageModel> images = <ImageModel>[].obs;
  RxList<DiagnosisTagModel>? diagnoses;
  RxList<SelectedMedicine>? obats;

  Pasiens({
    this.id,
    this.homeVisitOrderId,
    this.pasienId,
    this.policyNo,
    this.memberId,
    this.nama,
    this.tglLahir,
    this.gender,
    this.email,
    this.phone,
    this.beratBadan,
    this.tinggiBadan,
    this.alergi,
    this.keluhan,
    List<ImageModel>? images,
    this.diagnoses,
    this.obats,
  }) {
    if (images != null) {
      this.images.addAll(images);
    }
    if (diagnoses != null) {
      diagnoses!.addAll(diagnoses!);
    }
    if (obats != null) {
      obats!.addAll(obats!);
    }
  }

  Pasiens.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    homeVisitOrderId = json['home_visit_order_id'];
    pasienId = json['pasien_id'];
    policyNo = json['policy_no'];
    memberId = json['member_id'];
    nama = json['nama'];
    tglLahir = json['tgl_lahir'];
    gender = json['gender'] == 'L'
        ? 'Laki-laki'
        : json['gender'] == 'P'
            ? 'Perempuan'
            : json['gender'];
    email = json['email'];
    phone = json['phone'];
    beratBadan = json['berat_badan'];
    tinggiBadan = json['tinggi_badan'];
    alergi = json['alergi'];
    keluhan = json['keluhan'];

    // Assuming `id_card` is a String path or URL to the image
    images.value = (json['images'] as List<dynamic>?)
            ?.map((img) => ImageModel.fromJson(img))
            .toList() ??
        [];
    diagnoses = <DiagnosisTagModel>[].obs; // Initialize as empty
    obats = (json['obat'] as List<dynamic>?)
            ?.map((medicine) => SelectedMedicine.fromJson(medicine))
            .toList()
            .obs ??
        <SelectedMedicine>[].obs;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['home_visit_order_id'] = homeVisitOrderId;
    data['pasien_id'] = pasienId;
    data['policy_no'] = policyNo;
    data['member_id'] = memberId;
    data['nama'] = nama;
    data['tgl_lahir'] = tglLahir;
    data['gender'] = gender;
    data['email'] = email;
    data['phone'] = phone;
    data['berat_badan'] = beratBadan;
    data['tinggi_badan'] = tinggiBadan;
    data['alergi'] = alergi;
    data['keluhan'] = keluhan;
    data['images'] = images.map((img) => img.toJson()).toList();
    data['diagnoses'] = diagnoses?.map((diag) => diag.toJson()).toList();
    data['obat'] = obats?.map((medicine) => medicine.toJson()).toList();
    return data;
  }
}

class SelectedMedicine {
  ObatModel? obat; // Properti untuk menyimpan informasi obat
  int? jumlah;
  String? aturanPakai;
  String? keterangan;

  SelectedMedicine({
    this.obat,
    this.jumlah,
    this.aturanPakai,
    this.keterangan,
  });

  // Method fromJson untuk parsing JSON ke model
  factory SelectedMedicine.fromJson(Map<String, dynamic> json) {
    return SelectedMedicine(
      obat: json['obat'] != null ? ObatModel.fromJson(json['obat']) : null,
      jumlah: json['jumlah'],
      aturanPakai: json['aturan_pakai'],
      keterangan: json['keterangan'],
    );
  }

  // Method toJson untuk serialisasi model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'obat_id': obat?.id.toString(), // ID obat dari model ObatModel
      'obat_text': obat?.name, // Nama obat dari model ObatModel
      'jumlah': jumlah, // Jumlah obat
      'satuan': obat?.unit, // Satuan obat dari model ObatModel
      'price': obat?.price, // Harga obat
      'aturan_pakai': aturanPakai, // Aturan pakai
      'keterangan': keterangan, // Keterangan
    };
  }
}

// Model ImageModel
class ImageModel {
  int? id;
  int? homeVisitOrderId;
  int? homeVisitOrderPasienId;
  String? image;
  String? createdAt;
  String? updatedAt;

  ImageModel({
    this.id,
    this.homeVisitOrderId,
    this.homeVisitOrderPasienId,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  // Deserialisasi dari JSON
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      homeVisitOrderId: json['home_visit_order_id'],
      homeVisitOrderPasienId: json['home_visit_order_pasien_id'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Serialisasi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'home_visit_order_id': homeVisitOrderId,
      'home_visit_order_pasien_id': homeVisitOrderPasienId,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class LocationOrderModel {
  String? cityText;
  String? districtText;

  LocationOrderModel({
    this.cityText,
    this.districtText,
  });

  factory LocationOrderModel.fromJson(Map<String, dynamic> json) {
    return LocationOrderModel(
      cityText: json['city_text'],
      districtText: json['district_text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city_text': cityText,
      'district_text': districtText,
    };
  }
}
