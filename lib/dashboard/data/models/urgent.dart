class Notice {
  final int id;
  final int userId;
  final String title;
  final String content;
  final String tag;
  final int urgent;
  final String createdAt;
  final String updatedAt;
  final List<dynamic> noticeImages; 

  Notice({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.tag,
    required this.urgent,
    required this.createdAt,
    required this.updatedAt,
    required this.noticeImages,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
  var noticeJson = json['notices']; // 'notices' 키 아래의 데이터를 추출
  return Notice(
    id: noticeJson['id'],
    userId: noticeJson['user_id'],
    title: noticeJson['title'],
    content: noticeJson['content'],
    tag: noticeJson['tag'],
    urgent: noticeJson['urgent'],
    createdAt: noticeJson['created_at'],
    updatedAt: noticeJson['updated_at'],
    noticeImages: noticeJson['notice_images'] ?? [],
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'tag': tag,
      'urgent': urgent,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'notice_images': noticeImages,
    };
  }
}
