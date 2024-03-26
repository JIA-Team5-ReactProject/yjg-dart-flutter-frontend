import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:yjg/as(admin)/data/data_sources/as_comment_data_source.dart";
import "package:yjg/as(admin)/domain/entities/comment.dart";
import "package:yjg/as(admin)/domain/usecases/as_comment_usecase.dart";
import "package:yjg/as(admin)/presentation/viewmodels/as_viewmodel.dart";
import "package:yjg/as(admin)/presentation/viewmodels/comment_viewmodel.dart";
import "package:yjg/shared/theme/theme.dart";

void showAsWritingCommentModal(BuildContext context, WidgetRef ref) {
  final commentUseCases = CommentUseCases(AsCommentDataSource());
  final serviceId = ref.watch(serviceIdProvider.notifier).state;
  TextEditingController commentController = TextEditingController();
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        // 모달 내에서 상태를 업데이트하기 위해 StatefulBuilder 사용
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              // SingleChildScrollView 추가
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('댓글 작성',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Palette.mainColor),
                      ),
                      hintText: ' 댓글을 입력해주세요.',
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0), // 상하 패딩 조절

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () async {
                      Comment createComment = Comment(
                        serviceId: serviceId,
                        comment: commentController.text,
                      );

                      CommentResult result =
                          await commentUseCases.createComment(createComment);
                      Navigator.pop(context);

                      if (result.isSuccess) {
                        ref
                            .read(commentViewModelProvider.notifier)
                            .fetchComments(serviceId); // 상태 갱신

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.message),
                            backgroundColor: Palette.mainColor,
                          ),
                        );

                        // 모달 창 닫기
                      } else {
                        // 실패 시 실패 알림 표시
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text('작성',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      );
    },
    backgroundColor: Colors.transparent,
    isScrollControlled: true, // 모달의 크기를 조절하기 위해 필요
  );
}
