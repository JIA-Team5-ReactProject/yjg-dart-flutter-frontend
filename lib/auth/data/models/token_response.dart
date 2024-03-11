class Tokengenerated {
  User? user;
  String? accessToken;
  String? refreshToken;

  Tokengenerated({this.user, this.accessToken, this.refreshToken});

  Tokengenerated.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
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
  String? studentId;
  String? name;
  String? phoneNumber;
  String? email;
  int? approved;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.studentId,
      this.name,
      this.phoneNumber,
      this.email,
      this.approved,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    approved = json['approved'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['student_id'] = studentId;
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['approved'] = approved;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}