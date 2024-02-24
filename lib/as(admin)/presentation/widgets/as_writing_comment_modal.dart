import "package:flutter/material.dart";
import "package:yjg/shared/theme/theme.dart";

void showAsWritingCommentModal(BuildContext context) {
  // 추후 riverpod로 상태 관리 로직 추가
  bool isProcessing = false; // 상태 변경 체크박스 상태 관리를 위한 변수
  bool isCompleted = false; // 상태 변경 체크박스 상태 관리를 위한 변수
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
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Palette.mainColor),
                      ),
                      hintText: ' 댓글을 입력해주세요.',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0), // 상하 패딩 조절

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Divider(
                    color: Colors.grey.withOpacity(0.4),
                    thickness: 1.0,
                  ),
                  SizedBox(height: 20),
                  Text('상태 변경',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  CheckboxListTile(
                    title: Text("처리중"),
                    value: isProcessing,
                    activeColor: Palette.mainColor,
                    onChanged: (bool? value) {
                      setState(() {
                        isProcessing = value!;
                        // isCompleted를 false로 설정하여 체크박스를 하나만 선택할 수 있도록
                        if (isProcessing) isCompleted = false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text("처리완료"),
                    value: isCompleted,
                    activeColor: Palette.mainColor,
                    onChanged: (bool? value) {
                      setState(() {
                        isCompleted = value!;
                        // 마찬가지로, isProcessing을 false로 설정할 수 있습니다.
                        if (isCompleted) isProcessing = false;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () {
                      // 추후 댓글 작성 로직 추가
                      Navigator.pop(context); // 모달 닫기
                    },
                    child: Text('작성', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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
