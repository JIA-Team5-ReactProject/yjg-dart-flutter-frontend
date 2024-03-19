import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/shared/widgets/custom_rounded_button.dart';
import 'package:yjg/shared/theme/palette.dart';

class RoundedBox extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 학생 이름
    final studentName = ref.watch(studentNameProvider);

    return Container(
      width: double.infinity, // 상자의 너비
      height: 170, // 상자의 높이
      decoration: BoxDecoration(
        color: Palette.mainColor, // 상자의 색상
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
                  Text(studentName,
                    style: 
                        TextStyle(color: Palette.backgroundColor, fontSize: 18),
                  ),
                  SizedBox(height: 10), // 텍스트 - 버튼 간격
                  Row(
                    // 수평 정렬
                    children: <Widget>[
                      CustomRoundedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/bus_qr');
                          }, buttonText: '버스 QR'),
                      SizedBox(width: 8),
                      CustomRoundedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/meal_qr');
                          }, buttonText: '식수 QR'),
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
