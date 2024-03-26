import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yjg/as(admin)/data/data_sources/as_comment_data_source.dart';
import 'package:yjg/as(admin)/data/models/as_comment.dart';
import 'package:yjg/as(admin)/domain/entities/comment.dart';
import 'package:yjg/as(admin)/domain/usecases/as_comment_usecase.dart';
import 'package:yjg/as(admin)/presentation/viewmodels/comment_viewmodel.dart';
import 'package:yjg/as(admin)/presentation/widgets/as_updating_comment_modal.dart';
import 'package:yjg/auth/presentation/viewmodels/privilege_viewmodel.dart';
import 'package:yjg/shared/theme/theme.dart';

class AsCommentBox extends ConsumerStatefulWidget {
  final int serviceId;

  AsCommentBox({Key? key, required this.serviceId}) : super(key: key);

  @override
  _AsCommentBoxState createState() => _AsCommentBoxState();
}

class _AsCommentBoxState extends ConsumerState<AsCommentBox> {
  final commentUseCases = CommentUseCases(AsCommentDataSource());

  @override
  void initState() {
    super.initState();
    // initState에서 댓글 데이터를 불러옴
    Future.microtask(
      () => ref
          .read(commentViewModelProvider.notifier)
          .fetchComments(widget.serviceId),
    );
  }

  @override
  Widget build(BuildContext context) {
    // CommentViewModelProvider를 구독하여 댓글 데이터를 가져옴
    final commentsState = ref.watch(commentViewModelProvider);

    return commentsState.when(
      data: (comments) => comments.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("아직 댓글이 없습니다."),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: comments
                  .map((comment) => buildCommentItem(context, comment))
                  .toList(),
            ),
      loading: () => Center(child: CircularProgressIndicator(color: Palette.stateColor4)),
      error: (error, _) => Text('댓글을 불러오는데 실패했습니다.'),
    );
  }

  Widget buildCommentItem(BuildContext context, AfterServiceComment comment) {
    bool? isAdminValue = ref.watch(isAdminProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        height: 100.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.02),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Row(
                  children: [
                    Text(
                      '기사님',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 10.0),
                    if (comment.createdAt != null)
                      Text(
                        DateFormat('yyyy-MM-dd')
                            .format(DateTime.parse(comment.createdAt!)),
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Palette.textColor.withOpacity(0.5)),
                      ),
                    Spacer(),
                    if (isAdminValue!) buildEditButton(context, comment, ref),
                    if (isAdminValue) buildDeleteButton(context, comment, ref),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                child: Text(
                  comment.comment,
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditButton(
      BuildContext context, AfterServiceComment comment, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        showAsUpdatingCommentModal(
            context, comment.comment, comment.id, comment.afterServiceId, ref);
      },
      child: Icon(Icons.edit, size: 20.0, color: Palette.stateColor4),
    );
  }

  Widget buildDeleteButton(
      BuildContext context, AfterServiceComment comment, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        // 삭제 확인 다이얼로그 표시
        final confirmDelete = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('댓글 삭제'),
            content: Text('이 댓글을 삭제하시겠습니까?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('삭제'),
              ),
            ],
          ),
        );

        // 사용자가 삭제를 확인했다면, CommentViewModel을 통해 댓글 삭제 실행
        if (confirmDelete == true) {
          Comment deleteComment = Comment(
            commentId: comment.id,
          );

          CommentResult result =
              await commentUseCases.deleteComment(deleteComment);

          if (result.isSuccess) {
            ref
                .read(commentViewModelProvider.notifier)
                .fetchComments(comment.afterServiceId); // 상태 업데이트

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result.message),
                backgroundColor: Palette.mainColor,
              ),
            );
          } else {
            // 실패 시 실패 알림 표시
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: Icon(Icons.delete, size: 20.0, color: Palette.stateColor3),
    );
  }
}
