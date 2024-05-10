class Reservationsgenerated {
  List<Reservations>? reservations;

  Reservationsgenerated({this.reservations});

  Reservationsgenerated.fromJson(Map<String, dynamic> json) {
    if (json['reservations'] != null) {
      reservations = <Reservations>[];
      json['reservations'].forEach((v) {
        reservations!.add(Reservations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (reservations != null) {
      data['reservations'] = reservations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reservations {
  int? id;
  int? salonServiceId;
  int? userId;
  String? reservationDate;
  String? reservationTime;
  String? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  SalonService? salonService;

  Reservations(
      {this.id,
      this.salonServiceId,
      this.userId,
      this.reservationDate,
      this.reservationTime,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.salonService});

  Reservations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salonServiceId = json['salon_service_id'];
    userId = json['user_id'];
    reservationDate = json['reservation_date'];
    reservationTime = json['reservation_time'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    salonService = json['salon_service'] != null
        ? SalonService.fromJson(json['salon_service'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salon_service_id'] = salonServiceId;
    data['user_id'] = userId;
    data['reservation_date'] = reservationDate;
    data['reservation_time'] = reservationTime;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (salonService != null) {
      data['salon_service'] = salonService!.toJson();
    }
    return data;
  }
}

class SalonService {
  int? id;
  int? salonCategoryId;
  String? service;
  String? price;
  String? gender;
  String? createdAt;
  String? updatedAt;

  SalonService(
      {this.id,
      this.salonCategoryId,
      this.service,
      this.price,
      this.gender,
      this.createdAt,
      this.updatedAt});

  SalonService.fromJson(Map<String, dynamic> json) {
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
