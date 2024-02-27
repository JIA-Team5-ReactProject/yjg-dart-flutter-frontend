class Price {
  String? serviceType;
  String? gender;
  String? serviceName;
  int? price;

  Price({this.serviceType, this.gender, this.serviceName, this.price});

  Price.fromJson(Map<String, dynamic> json) {
    serviceType = json['service_type'];
    gender = json['gender'];
    serviceName = json['service_name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['service_type'] = serviceType;
    data['gender'] = gender;
    data['service_name'] = serviceName;
    data['price'] = price;
    return data;
  }
}
