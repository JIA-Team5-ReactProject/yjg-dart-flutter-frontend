import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yjg/as(admin)/data/data_sources/as_comment_data_source.dart';
import 'package:yjg/as(admin)/data/models/as_list.dart';
import 'package:yjg/as(admin)/domain/entities/comment.dart';
import 'package:yjg/as(admin)/domain/usecases/as_comment_usecase.dart';
import 'package:yjg/as(admin)/presentation/widgets/as_updating_comment_modal.dart';
import 'package:yjg/shared/theme/theme.dart'; // 필요에 따라 경로 확인
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AsCommentBox extends ConsumerStatefulWidget {
  // ConsumerStatefulWidget을 상속합니다.

  AsCommentBox({Key? key, required this.comments}) : super(key: key);

  final List<AfterServiceComment> comments;

  @override
  _AsCommentBoxState createState() => _AsCommentBoxState();
}

class _AsCommentBoxState extends ConsumerState<AsCommentBox> {
  final commentUseCases = CommentUseCases(AsCommentDataSource());

  bool isAdmin = false;
  static final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkIfAdmin();
  }

  // storage에서 isAdmin 값을 읽어와서 상태를 업데이트하는 메소드
  Future<void> _checkIfAdmin() async {
    final isAdminValue = await storage.read(key: 'isAdmin');
    setState(() {
      isAdmin = isAdminValue == 'true';
      debugPrint('isAdmin: $isAdmin');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.comments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text("아직 댓글이 없습니다."),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widget.comments
          .map((comment) => Padding(
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                '기사님',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                DateFormat('yyyy-MM-dd')
                                    .format(DateTime.parse(comment.createdAt)),
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Palette.textColor.withOpacity(0.5)),
                              ),
                              Spacer(),
                              if (isAdmin)
                                GestureDetector(
                                  onTap: () {
                                    showAsUpdatingCommentModal(context,
                                        comment.comment, comment.id, ref);
                                  },
                                  child: Text(
                                    '수정',
                                    style: TextStyle(
                                        color: Palette.stateColor4,
                                        fontSize: 12.0),
                                  ),
                                ),
                              SizedBox(width: 10.0),
                              if (isAdmin)
                                GestureDetector(
                                  onTap: () async {
                                    Comment deleteComment = Comment(
                                      commentId: comment.id,
                                    );

                                    CommentResult result = await commentUseCases
                                        .deleteComment(deleteComment);

                                    if (result.isSuccess) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(result.message),
                                          backgroundColor: Palette.mainColor,
                                        ),
                                      );

                                    } else {
                                      // 실패 시 실패 알림 표시
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(result.message),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(
                                    '삭제',
                                    style: TextStyle(
                                        color: Palette.stateColor3,
                                        fontSize: 12.0),
                                  ),
                                ),
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
              ))
          .toList(),
    );
  }
}
