import 'package:yjg/as(admin)/data/data_sources/as_comment_data_source.dart';
import 'package:yjg/as(admin)/domain/entities/comment.dart';


class CommentResult {
  final bool isSuccess;
  final String message;

  CommentResult({required this.isSuccess, required this.message});
}

class CommentUseCases {
  final AsCommentDataSource dataSource;

  CommentUseCases(this.dataSource);

  Future<CommentResult> createComment(Comment comment) async {
    try {
      final response = await dataSource.postCommentAPI(
        comment.serviceId!,
        comment.comment!,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return CommentResult(isSuccess: true, message: '댓글이 성공적으로 생성되었습니다.');
      } else {
        return CommentResult(
            isSuccess: false, message: '댓글 생성 실패: ${response.body}');
      }
    } catch (e) {
      return CommentResult(isSuccess: false, message: '댓글 생성 중 에러 발생: $e');
    }
  }

  Future<CommentResult> updateComment(Comment comment) async {
    try {
      final response = await dataSource.patchCommentAPI(
        comment.commentId!,
        comment.comment!,
      );

      if (response.statusCode == 200) {
        return CommentResult(isSuccess: true, message: '댓글이 성공적으로 업데이트되었습니다.');
      } else {
        return CommentResult(
            isSuccess: false, message: '댓글 수정 실패: ${response.body}');
      }
    } catch (e) {
      return CommentResult(isSuccess: false, message: '댓글 수정 중 에러 발생: $e');
    }
  }

  Future<CommentResult> deleteComment(Comment comment) async {
    try {
      final response = await dataSource.deleteCommentAPI(
        comment.commentId!,
      );

      if (response.statusCode == 200) {
        return CommentResult(isSuccess: true, message: '댓글이 성공적으로 삭제되었습니다.');
      } else {
        return CommentResult(
            isSuccess: false, message: '댓글 삭제 실패: ${response.body}');
      }
    } catch (e) {
      return CommentResult(isSuccess: false, message: '댓글 삭제 중 에러 발생: $e');
    }
  }
}
