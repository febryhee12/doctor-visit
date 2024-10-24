class ObatModel {
  int? id;
  String? name;
  String? price;
  String? unit;
  String? type;

  ObatModel({
    this.id,
    this.name,
    this.price,
    this.unit,
    this.type,
  });

  factory ObatModel.fromJson(Map<String, dynamic> json) {
    return ObatModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      unit: json['unit'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'unit': unit,
      'type': type,
    };
  }
}
