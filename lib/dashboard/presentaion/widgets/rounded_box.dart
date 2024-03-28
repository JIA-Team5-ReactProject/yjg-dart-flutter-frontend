import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/widgets/custom_rounded_button.dart';
import 'package:yjg/shared/theme/palette.dart';

class RoundedBox extends StatelessWidget {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  RoundedBox({super.key});

  Future<String?> getUserInfo() async {
    return await storage.read(key: 'name');
  }

  @override
  Widget build(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image(
              image: AssetImage('assets/img/yju_tiger_logo.png'),
              width: 100,
              height: 100,
            ),
            SizedBox(width: 20), // 이미지와 텍스트 사이의 간격
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder<String?>(
                    future: getUserInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      return Text(
                        snapshot.data ?? '정보 없음',
                        style: TextStyle(color: Palette.backgroundColor, fontSize: 18),
                      );
                    },
                  ),
                  SizedBox(height: 10), // 텍스트와 버튼 간격
                  Row(
                    children: <Widget>[
                      CustomRoundedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/bus_qr');
                          },
                          buttonText: '버스 QR'),
                      SizedBox(width: 8),
                      CustomRoundedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/meal_qr');
                          },
                          buttonText: '식수 QR'),
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
