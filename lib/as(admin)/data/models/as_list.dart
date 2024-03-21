class AfterServiceResponse {
  final int currentPage;
  final List<AfterService> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<PageLink> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  AfterServiceResponse({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });
  factory AfterServiceResponse.fromJson(Map<String, dynamic> json) {
    final afterServices = json['after_services']
        as Map<String, dynamic>; // 'after_services' 객체 접근
    return AfterServiceResponse(
      currentPage: afterServices['current_page'] ?? 1,
      data: afterServices['data'] != null
          ? List<AfterService>.from(
              afterServices['data'].map((x) => AfterService.fromJson(x)))
          : [],
      firstPageUrl: afterServices['first_page_url'] ?? '',
      from: afterServices['from'] ?? 0,
      lastPage: afterServices['last_page'] ?? 1,
      lastPageUrl: afterServices['last_page_url'] ?? '',
      links: afterServices['links'] != null
          ? List<PageLink>.from(
              afterServices['links'].map((x) => PageLink.fromJson(x)))
          : [],
      nextPageUrl: afterServices['next_page_url'],
      path: afterServices['path'] ?? '',
      perPage: afterServices['per_page'] ?? 0,
      prevPageUrl: afterServices['prev_page_url'],
      to: afterServices['to'] ?? 0,
      total: afterServices['total'] ?? 0,
    );
  }
}

class AfterService {
  final int id;
  final int userId;
  final String title;
  final String content;
  final int status;
  final String visitPlace;
  final String visitDate;
  final String createdAt;
  final String updatedAt;
  final String userName;
  final List<AfterServiceComment> afterServiceComments;
  final List<dynamic> afterServiceImages;

  AfterService({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.status,
    required this.visitPlace,
    required this.visitDate,
    required this.createdAt,
    required this.updatedAt,
    required this.userName,
    required this.afterServiceComments,
    required this.afterServiceImages,
  });

  // 댓글 생성
  void addComment(AfterServiceComment newComment) {
    afterServiceComments.add(newComment);
  }

  // 댓글 업데이트
  void updateComment(AfterServiceComment updatedComment) {
    int index = afterServiceComments
        .indexWhere((comment) => comment.id == updatedComment.id);
    if (index != -1) {
      afterServiceComments[index] = updatedComment;
    } else {
      afterServiceComments.add(updatedComment);
    }
  }

  factory AfterService.fromJson(Map<String, dynamic> json) => AfterService(
        id: json['id'],
        userId: json['user_id'],
        title: json['title'],
        content: json['content'],
        status: json['status'],
        visitPlace: json['visit_place'],
        visitDate: json['visit_date'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        userName: json['user_name'],
        afterServiceComments: json['after_service_comments'] == null
            ? []
            : List<AfterServiceComment>.from(json['after_service_comments']
                .map((x) => AfterServiceComment.fromJson(x))),
        afterServiceImages: json['after_service_images'] == null
            ? []
            : List<dynamic>.from(json['after_service_images'].map((x) => x)),
      );
}

class AfterServiceComment {
  final int id;
  final int adminId;
  final int afterServiceId;
  final String comment;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;

  AfterServiceComment({
    required this.id,
    required this.adminId,
    required this.afterServiceId,
    required this.comment,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AfterServiceComment.fromJson(Map<String, dynamic> json) =>
      AfterServiceComment(
        id: json['id'],
        adminId: json['admin_id'],
        afterServiceId: json['after_service_id'],
        comment: json['comment'],
        deletedAt: json['deleted_at'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );
}

class PageLink {
  final String? url;
  final String label;
  final bool active;

  PageLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory PageLink.fromJson(Map<String, dynamic> json) => PageLink(
        url: json['url'],
        label: json['label'],
        active: json['active'],
      );
}
