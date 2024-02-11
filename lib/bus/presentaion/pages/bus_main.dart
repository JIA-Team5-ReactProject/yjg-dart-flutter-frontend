import "package:flutter/material.dart";
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/notice_box.dart';
import 'package:yjg/shared/widgets/white_main_rounded_box.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:yjg/shared/widgets/move_button.dart';


class BusMain extends StatelessWidget {
  const BusMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: '버스'),
      drawer: Drawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                      iconData: Icons.directions_bus,
                      mainText: '글로벌캠퍼스',
                      secondaryText: '탑승인원: 12명(45인승)',
                      actionText: '위치 변경',
                      timeText: '14:00',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            alignment: Alignment(-0.85, 0.2),
            child: const Text(
              '버스 이용하기',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          //이동 버튼 배치
          const Wrap(
            spacing: 30, // 아이템들 사이의 가로 간격
            runSpacing: 30, // 아이템들 사이의 세로 간격
            children: <Widget>[
              MoveButton(
                  icon: Icons.schedule,
                  text1: '시간표',
                  text2: '버스 시간표 확인',
                  route: '/bus_schedule'),
              MoveButton(
                  icon: Icons.qr_code,
                  text1: '버스QR',
                  text2: '버스 탑승 시 QR 찍기',
                  route: '/bus_qr'),
            ],
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.all(20),
            alignment: Alignment(-0.85, 0.2),
            child: const Text(
              '버스 공지사항',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 140.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [

                  // TODO: 나중에 통신(최근 3개만 가져오게 처리)
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 20.0), // 오른쪽에 20픽셀 간격을 줍니다.
                    child: NoticeBox(
                      title: '2024년도 1학기 버스 시간표 변경',
                      content:
                          '2024년도 1학기 버스 시간표 변동사항을 공지합니다.....',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 20.0), // 오른쪽에 20픽셀 간격을 줍니다.
                    child: NoticeBox(
                      title: '2024년도 1학기 버스 시간표 변경',
                      content:
                          '2024년도 1학기 버스 시간표 변동사항을 공지합니다.....',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 20.0), // 오른쪽에 20픽셀 간격을 줍니다.
                    child: NoticeBox(
                      title: '2024년도 1학기 버스 시간표 변경',
                      content:
                          '2024년도 1학기 버스 시간표 변동사항을 공지합니다.....',
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}