class Noticegenerated {
  List<Notices>? notices;

  Noticegenerated({this.notices});

  Noticegenerated.fromJson(Map<String, dynamic> json) {
    if (json['notices'] != null) {
      notices = <Notices>[];
      json['notices'].forEach((v) {
        notices!.add(Notices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (notices != null) {
      data['notices'] = notices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notices {
  int? id;
  int? adminId;
  String? title;
  String? content;
  String? tag;
  int? urgent;
  String? createdAt;
  String? updatedAt;
  List<String>? noticeImages;

  Notices(
      {this.id,
      this.adminId,
      this.title,
      this.content,
      this.tag,
      this.urgent,
      this.createdAt,
      this.updatedAt,
      this.noticeImages});

  Notices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adminId = json['admin_id'];
    title = json['title'];
    content = json['content'];
    tag = json['tag'];
    urgent = json['urgent'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['notice_images'] != null) {
      noticeImages = List<String>.from(json['notice_images']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['admin_id'] = adminId;
    data['title'] = title;
    data['content'] = content;
    data['tag'] = tag;
    data['urgent'] = urgent;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (noticeImages != null) {
      data['notice_images'] = noticeImages!;
    }
    return data;
  }
}
