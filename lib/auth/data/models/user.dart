class Usergenerated {
  User? user;
  String? accessToken;
  String? refreshToken;

  Usergenerated({this.user, this.accessToken, this.refreshToken});

  Usergenerated.fromJson(Map<String, dynamic> json) {
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
  List<Privileges>? privileges;

  User(
      {this.id,
      this.studentId,
      this.name,
      this.phoneNumber,
      this.email,
      this.approved,
      this.createdAt,
      this.updatedAt,
      this.privileges});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    approved = json['approved'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['privileges'] != null) {
      privileges = <Privileges>[];
      json['privileges'].forEach((v) {
        privileges!.add(Privileges.fromJson(v));
      });
    }
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
    if (privileges != null) {
      data['privileges'] = privileges!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Privileges {
  int? id;
  String? privilege;
  Pivot? pivot;

  Privileges({this.id, this.privilege, this.pivot});

  Privileges.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    privilege = json['privilege'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['privilege'] = privilege;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? userId;
  int? privilegeId;

  Pivot({this.userId, this.privilegeId});

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    privilegeId = json['privilege_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['privilege_id'] = privilegeId;
    return data;
  }
}