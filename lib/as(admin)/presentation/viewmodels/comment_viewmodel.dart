import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/as(admin)/data/data_sources/as_comment_data_source.dart';
import 'package:yjg/as(admin)/data/models/as_comment.dart';

final commentViewModelProvider = StateNotifierProvider<CommentViewModel,
    AsyncValue<List<AfterServiceComment>>>((ref) {
  return CommentViewModel();
});

class CommentViewModel
    extends StateNotifier<AsyncValue<List<AfterServiceComment>>> {
  CommentViewModel() : super(AsyncValue.loading());

  Future<void> fetchComments(int serviceId) async {
    state = AsyncValue.loading();
    try {
      final dataSource = AsCommentDataSource();
      final response = await dataSource.getCommentAPI(serviceId);
      final data = response.data;
      final List<dynamic> commentsJson = data['after_service_comments'];
      // 'after_service_comments' 키의 값을 List<AfterServiceComment>로 변환
      final List<AfterServiceComment> comments = commentsJson
          .map((e) => AfterServiceComment.fromJson(e as Map<String, dynamic>))
          .toList();
      state = AsyncValue.data(comments);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      debugPrint('fetchComments error: $e, stack trace: $s');
    }
  }

  // 댓글 추가, 수정, 삭제 후 상태 갱신을 위한 메서드
  void addComment(AfterServiceComment comment) {
    state.whenData((comments) =>
        state = AsyncValue.data(List.from(comments)..add(comment)));
  }

  void updateComment(AfterServiceComment updatedComment) {
    state.whenData((comments) {
      final index =
          comments.indexWhere((comment) => comment.id == updatedComment.id);
      if (index != -1) {
        final newList = List<AfterServiceComment>.from(comments);
        newList[index] = updatedComment;
        state = AsyncValue.data(newList);
      }
    });
  }

  void deleteComment(int commentId) {
    state.whenData((comments) => state = AsyncValue.data(
        comments.where((comment) => comment.id != commentId).toList()));
  }
}
