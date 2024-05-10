class AfterServiceComment {
  final int id;
  final int userId;
  final int afterServiceId;
  final String comment;
  final String createdAt;
  final String updatedAt;

  AfterServiceComment({
    required this.id,
    required this.userId,
    required this.afterServiceId,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AfterServiceComment.fromJson(Map<String, dynamic> json) {
    return AfterServiceComment(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      afterServiceId: json['after_service_id'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'after_service_id': afterServiceId,
      'comment': comment,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
