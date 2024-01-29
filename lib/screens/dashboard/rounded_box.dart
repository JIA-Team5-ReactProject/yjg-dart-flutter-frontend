import 'package:flutter/material.dart';
import 'package:yjg/common/custom_rounded_button.dart';
import 'package:yjg/theme/pallete.dart';

class RoundedBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // 상자의 너비
      height: 170, // 상자의 높이
      decoration: BoxDecoration(
        color: Pallete.mainColor, // 상자의 색상
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0), // 왼쪽 아래 모서리 둥글기
          bottomRight: Radius.circular(20.0), // 오른쪽 아래 모서리 둥글기
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // 내부 여백 조정
        child: Row(
          // 수평 정렬
          crossAxisAlignment: CrossAxisAlignment.start, // 시작 부분에서 정렬
          children: <Widget>[
            Image(
              image: AssetImage('assets/img/yju_tiger_logo.png'),
              width: 100,
              height: 100,
            ),
            SizedBox(width: 20), // 이미지와 텍스트 사이의 간격
            Expanded(
              // 텍스트와 버튼을 위한 공간을 나머지로 확장
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 자식들을 시작 부분에서 정렬
                mainAxisAlignment: MainAxisAlignment.start, // 위젯들을 위쪽으로 정렬
                children: <Widget>[
                  SizedBox(height: 10),
                  Text(
                    '김영진님', // TODO: 추후 API 연동 후 사용자 이름으로 변경
                    style:
                        TextStyle(color: Pallete.backgroundColor, fontSize: 18),
                  ),
                  SizedBox(height: 10), // 텍스트 - 버튼 간격
                  Row(
                    // 수평 정렬
                    children: <Widget>[
                      CustomRoundedButton(
                          onPressed: () {}, buttonText: '버스 QR'),
                      SizedBox(width: 8),
                      CustomRoundedButton(
                          onPressed: () {}, buttonText: '식수 QR'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
