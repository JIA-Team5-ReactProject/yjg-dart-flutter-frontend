import "package:flutter/material.dart";
import 'package:yjg/common/blue_main_rounded_box.dart';
import "package:yjg/common/notice_box.dart";
import "package:yjg/common/white_main_rounded_box.dart";
import "package:yjg/widgets/base_appbar.dart";
import "package:yjg/widgets/bottom_navigation_bar.dart";
import "package:yjg/widgets/move_button.dart";

class SalonMain extends StatelessWidget {
  const SalonMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: '미용실'),
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
                      iconData: Icons.cut,
                      mainText: '미용실 예약이 있습니다.',
                      secondaryText: '고속도로컷',
                      actionText: '예약 취소',
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
              '미용실 이용하기',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          //이동 버튼 배치
          const Wrap(
            spacing: 30, // 아이템들 사이의 가로 간격
            runSpacing: 30, // 아이템들 사이의 세로 간격
            children: <Widget>[
              MoveButton(
                  icon: Icons.add_task,
                  text1: '예약',
                  text2: '미용실 예약',
                  route: '/salon_booking'),
              MoveButton(
                  icon: Icons.content_paste_search,
                  text1: '가격표',
                  text2: '미용실 이용 가격 안내',
                  route: '/salon_price_list'),
            ],
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.all(20),
            alignment: Alignment(-0.85, 0.2),
            child: const Text(
              '미용실 공지사항',
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
                      title: '미용실 휴무 안내',
                      content:
                          '미용실 휴무합니다. 2025년 1월 1일부터 2025년 1월 3일까지 휴무이므로, 이용....',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 20.0), // 오른쪽에 20픽셀 간격을 줍니다.
                    child: NoticeBox(
                      title: '미용실 휴무 안내',
                      content:
                          '미용실 휴무합니다. 2025년 1월 1일부터 2025년 1월 3일까지 휴무이므로, 이용....',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 20.0), // 오른쪽에 20픽셀 간격을 줍니다.
                    child: NoticeBox(
                      title: '미용실 휴무 안내',
                      content:
                          '미용실 휴무합니다. 2025년 1월 1일부터 2025년 1월 3일까지 휴무이므로, 이용....',
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
