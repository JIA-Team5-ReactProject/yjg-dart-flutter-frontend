class Admingenerated {
  Admin? admin;
  String? token;

  Admingenerated({this.admin, this.token});

  Admingenerated.fromJson(Map<String, dynamic> json) {
    admin = json['admin'] != null ? Admin.fromJson(json['admin']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (admin != null) {
      data['admin'] = admin!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class Admin {
  int? id;
  String? name;
  String? phoneNumber;
  String? email;
  int? salonPrivilege;
  int? restaurantPrivilege;
  int? adminPrivilege;
  int? approved;
  int? master;
  String? createdAt;
  String? updatedAt;

  Admin(
      {this.id,
      this.name,
      this.phoneNumber,
      this.email,
      this.salonPrivilege,
      this.restaurantPrivilege,
      this.adminPrivilege,
      this.approved,
      this.master,
      this.createdAt,
      this.updatedAt});

  Admin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    salonPrivilege = json['salon_privilege'];
    restaurantPrivilege = json['restaurant_privilege'];
    adminPrivilege = json['admin_privilege'];
    approved = json['approved'];
    master = json['master'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['salon_privilege'] = salonPrivilege;
    data['restaurant_privilege'] = restaurantPrivilege;
    data['admin_privilege'] = adminPrivilege;
    data['approved'] = approved;
    data['master'] = master;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}