class DoctorModel {
  int? id;
  String? uuid;
  String? username;
  String? name;
  String? email;
  String? noTelp;
  String? emailVerifiedAt;
  int? groupKlinikId;
  int? klinikId;
  String? avatar;
  String? alamat;
  String? districtCode;
  String? cityCode;
  String? provinceCode;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? isDokterVm;
  int? homeVisitActive;
  int? homeVisitStatus;
  // Null longlitude;
  // Null latitude;
  int? otherLanguage;
  int? gender;

  DoctorModel({
    this.id,
    this.uuid,
    this.username,
    this.name,
    this.email,
    this.noTelp,
    this.emailVerifiedAt,
    this.groupKlinikId,
    this.klinikId,
    this.avatar,
    this.alamat,
    this.districtCode,
    this.cityCode,
    this.provinceCode,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.isDokterVm,
    this.homeVisitActive,
    this.homeVisitStatus,
    // this.longlitude,
    // this.latitude,
    this.otherLanguage,
    this.gender,
  });

  DoctorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    username = json['username'];
    name = json['name'] ?? '';
    email = json['email'];
    noTelp = json['no_telp'];
    emailVerifiedAt = json['email_verified_at'];
    groupKlinikId = json['group_klinik_id'];
    klinikId = json['klinik_id'];
    avatar = json['avatar'];
    alamat = json['alamat'];
    districtCode = json['district_code'];
    cityCode = json['city_code'];
    provinceCode = json['province_code'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isDokterVm = json['is_dokter_vm'];
    homeVisitActive = json['home_visit_active'];
    homeVisitStatus = json['home_visit_status'];
    // longlitude = json['longlitude'];
    // latitude = json['latitude'];
    otherLanguage = json['other_language'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['username'] = username;
    data['name'] = name;
    data['email'] = email;
    data['no_telp'] = noTelp;
    data['email_verified_at'] = emailVerifiedAt;
    data['group_klinik_id'] = groupKlinikId;
    data['klinik_id'] = klinikId;
    data['avatar'] = avatar;
    data['alamat'] = alamat;
    data['district_code'] = districtCode;
    data['city_code'] = cityCode;
    data['province_code'] = provinceCode;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_dokter_vm'] = isDokterVm;
    data['home_visit_active'] = homeVisitActive;
    data['home_visit_status'] = homeVisitStatus;
    // data['longlitude'] = longlitude;
    // data['latitude'] = latitude;
    data['other_language'] = otherLanguage;
    data['gender'] = gender;
    return data;
  }
}
