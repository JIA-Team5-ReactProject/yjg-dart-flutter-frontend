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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['service_type'] = this.serviceType;
    data['gender'] = this.gender;
    data['service_name'] = this.serviceName;
    data['price'] = this.price;
    return data;
  }
}
