import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/as(admin)/domain/entities/comment.dart';
import 'package:yjg/shared/theme/theme.dart';

import '../../data/data_sources/as_comment_data_source.dart';
import '../../domain/usecases/as_comment_usecase.dart';

void showAsUpdatingCommentModal(
    BuildContext context, String comment, int commentId, WidgetRef ref) {
  TextEditingController commentController =
      TextEditingController(text: comment);
  final commentUseCases = CommentUseCases(AsCommentDataSource());
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '댓글 수정',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: commentController, // 수정 폼에 추가된 컨트롤러
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
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
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
                      Comment updateComment = Comment(
                        commentId: commentId,
                        comment: commentController.text,
                      );

                      CommentResult result =
                          await commentUseCases.updateComment(updateComment);

                      if (result.isSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.message),
                            backgroundColor: Palette.mainColor,
                          ),
                        );

                        // 모달 창 닫기
                        Navigator.pop(context);
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
                    child: Text(
                      '수정',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
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
    isScrollControlled: true,
  );
}
