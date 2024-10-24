class DiagnosisTagModel {
  int? id;
  String? uuid;
  dynamic usersId;
  int? groupKlinikId;
  int? klinikId;
  String? kdDiag;
  String? nmDiag;
  String? nonSpesialis;
  String? createdAt;
  String? updatedAt;
  int? public;
  String? alias;
  int? isIcd10;
  int? isBpjs;
  int? isSatuSehat;

  DiagnosisTagModel(
      {this.id,
      this.uuid,
      this.usersId,
      this.groupKlinikId,
      this.klinikId,
      this.kdDiag,
      this.nmDiag,
      this.nonSpesialis,
      this.createdAt,
      this.updatedAt,
      this.public,
      this.alias,
      this.isIcd10,
      this.isBpjs,
      this.isSatuSehat});

  DiagnosisTagModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    usersId = json['users_id'];
    groupKlinikId = json['group_klinik_id'];
    klinikId = json['klinik_id'];
    kdDiag = json['kdDiag'];
    nmDiag = json['nmDiag'];
    nonSpesialis = json['nonSpesialis'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    public = json['public'];
    alias = json['alias'] ?? '';
    isIcd10 = json['is_icd10'];
    isBpjs = json['is_bpjs'];
    isSatuSehat = json['is_satu_sehat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['users_id'] = usersId;
    data['group_klinik_id'] = groupKlinikId;
    data['klinik_id'] = klinikId;
    data['kdDiag'] = kdDiag;
    data['nmDiag'] = nmDiag;
    data['nonSpesialis'] = nonSpesialis;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['public'] = public;
    data['alias'] = alias;
    data['is_icd10'] = isIcd10;
    data['is_bpjs'] = isBpjs;
    data['is_satu_sehat'] = isSatuSehat;
    return data;
  }
}
