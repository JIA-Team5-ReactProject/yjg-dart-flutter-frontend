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
class NoticeImage {
  final String image;
  final String createdAt;
  final String updatedAt;

  NoticeImage({required this.image, required this.createdAt, required this.updatedAt});

  factory NoticeImage.fromJson(Map<String, dynamic> json) {
    return NoticeImage(
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Notices {
  int? id;
  int? userId;
  String? title;
  String? content;
  String? tag;
  int? urgent;
  String? createdAt;
  String? updatedAt;
  List<NoticeImage>? noticeImages;

  Notices({
    this.id,
    this.userId,
    this.title,
    this.content,
    this.tag,
    this.urgent,
    this.createdAt,
    this.updatedAt,
    this.noticeImages,
  });

  Notices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    content = json['content'];
    tag = json['tag'];
    urgent = json['urgent'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['notice_images'] != null) {
      noticeImages = (json['notice_images'] as List)
          .map((v) => NoticeImage.fromJson(v))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['content'] = content;
    data['tag'] = tag;
    data['urgent'] = urgent;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (noticeImages != null) {
      data['notice_images'] = noticeImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
