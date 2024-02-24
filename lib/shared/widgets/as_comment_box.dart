import "package:flutter/material.dart";
import "package:yjg/shared/theme/theme.dart";

class AsCommentBox extends StatelessWidget {
  const AsCommentBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: SizedBox(
        height: 100.0,
        width: MediaQuery.of(context).size.width * 0.90,
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
            children: [
              SizedBox(
                height: 10.0,
              ),
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
                    Text(
                      '2024-02-22',
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Palette.textColor.withOpacity(0.5)),
                    ), // 임시데이터
                    Spacer(),
                    GestureDetector(
                      child: Text(
                        '수정',
                        style: TextStyle(
                            color: Palette.stateColor4, fontSize: 12.0),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    GestureDetector(
                      child: Text(
                        '삭제',
                        style: TextStyle(
                            color: Palette.stateColor3, fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                child: Text(
                  '2월 23일 10시~12시 사이 방문 예정입니다.',
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
