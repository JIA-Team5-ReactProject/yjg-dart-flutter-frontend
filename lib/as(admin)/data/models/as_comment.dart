class AfterServiceComment {
  final int id;
  final int adminId;
  final int afterServiceId;
  final String comment;
  final String createdAt;
  final String updatedAt;

  AfterServiceComment({
    required this.id,
    required this.adminId,
    required this.afterServiceId,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AfterServiceComment.fromJson(Map<String, dynamic> json) {
    return AfterServiceComment(
      id: json['id'],
      adminId: json['admin_id'],
      afterServiceId: json['after_service_id'],
      comment: json['comment'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_id': adminId,
      'after_service_id': afterServiceId,
      'comment': comment,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
