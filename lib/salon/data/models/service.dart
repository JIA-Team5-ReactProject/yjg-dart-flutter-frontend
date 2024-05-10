class Servicegenerated {
  List<Services>? services;

  Servicegenerated({this.services});

  Servicegenerated.fromJson(Map<String, dynamic> json) {
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  int? id;
  int? salonCategoryId;
  String? service;
  String? price;
  String? gender;
  String? createdAt;
  String? updatedAt;

  Services(
      {this.id,
      this.salonCategoryId,
      this.service,
      this.price,
      this.gender,
      this.createdAt,
      this.updatedAt});

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salonCategoryId = json['salon_category_id'];
    service = json['service'];
    price = json['price'];
    gender = json['gender'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salon_category_id'] = salonCategoryId;
    data['service'] = service;
    data['price'] = price;
    data['gender'] = gender;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}