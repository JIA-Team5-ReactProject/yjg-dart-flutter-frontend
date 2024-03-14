class Admingenerated {
  User? user;
  String? accessToken;
  String? refreshToken;

  Admingenerated({this.user, this.accessToken, this.refreshToken});

  Admingenerated.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    return data;
  }
}

class User {
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

  User(
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

  User.fromJson(Map<String, dynamic> json) {
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