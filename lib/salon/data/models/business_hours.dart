class BusinessHoursgenerated {
  List<BusinessHours>? businessHours;

  BusinessHoursgenerated({this.businessHours});

  BusinessHoursgenerated.fromJson(Map<String, dynamic> json) {
    if (json['business_hours'] != null) {
      businessHours = <BusinessHours>[];
      json['business_hours'].forEach((v) {
        businessHours!.add(new BusinessHours.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (businessHours != null) {
      data['business_hours'] =
          businessHours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BusinessHours {
  String? time;
  bool? available;

  BusinessHours({this.time, this.available});

  BusinessHours.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    available = json['available'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['available'] = available;
    return data;
  }
}
