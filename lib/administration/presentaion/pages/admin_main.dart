import 'package:flutter/material.dart';
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/white_main_rounded_box.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:yjg/shared/widgets/move_button.dart';

//임의 나중에 제거
var person =  8;

class AdminMain extends StatefulWidget {
  const AdminMain({super.key});

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: '행정'),
      drawer: const BaseDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //겹쳐진 박스
            SizedBox(
              height: 150.0,
              child: Stack(
                children: [
                  BlueMainRoundedBox(),
                  Positioned(
                    top: 15,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: WhiteMainRoundedBox(
                        iconData: Icons.headset_mic,
                        mainText: '생활관B동 - 208호',
                        secondaryText: '회의실 예약 인권: $person명',
                        actionText: '예약취소',
                        timeText: '',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //식수 이용하기 글자
            Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment(-0.85, 0.2),
              child: const Text(
                '행정 이용하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            //이동 버튼 배치
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: const Wrap(
                spacing: 30, // 아이템들 사이의 가로 간격
                runSpacing: 30, // 아이템들 사이의 세로 간격
                children: <Widget>[
                  MoveButton(
                      icon: Icons.volume_mute_outlined,
                      text1: '공지사항',
                      text2: '생활관 공지사항',
                      route: '/notice'),
                  MoveButton(
                      icon: Icons.construction_outlined,
                      text1: 'AS 요청',
                      text2: '글로벌캠퍼스 AD',
                      route: ''),
                  MoveButton(
                      icon: Icons.hotel_outlined,
                      text1: '외박/외출 신청',
                      text2: '외박,외출 신청',
                      route: ''),
                  MoveButton(
                      icon: Icons.groups,
                      text1: '회의실 예약',
                      text2: '생활관,라운지 회의실 예약',
                      route: ''),
                ],
              ),
            ),

            //AS현재 진행도
            Container(
              height: 80,
              width: 330,
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Palette.stateColor4.withOpacity(0.5),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: Palette.mainColor.withOpacity(0.1),
                    radius: 30.0,
                    child: Icon(
                      Icons.construction,
                      color: Palette.mainColor.withOpacity(0.7),
                      size: 30.0,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'AS 방문 예정',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Palette.textColor,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 3.0), // 텍스트 간격 조절
                        Text(
                          '거실등 불량',
                          style: TextStyle(
                            color: Palette.stateColor4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '13:00 예상',
                    style: TextStyle(
                      color: Palette.mainColor,
                      fontWeight: FontWeight.bold,
                    ),
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
