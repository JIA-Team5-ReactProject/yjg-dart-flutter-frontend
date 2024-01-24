import 'package:flutter/material.dart';
import 'package:yjg/common/mini_rounded_box.dart';
import 'package:yjg/screens/dashboard/rounded_box.dart';
import 'package:yjg/screens/restaurant/restaurant_main.dart';
import 'package:yjg/theme/pallete.dart';
import 'package:yjg/widgets/base_appbar.dart';
import 'package:yjg/widgets/bottom_navigation_bar.dart';

class DashboardMain extends StatelessWidget {
  const DashboardMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                child: RoundedBox(), // Your rounded box here
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Transform.translate(
                  offset: Offset(0, 8.0),
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 30,
                      runSpacing: 30,
                      children: <Widget>[
                        buildButton(context, Icons.directions_bus, '버스',
                            '버스 시간표, 버스 QR', '/bus_main'),
                        buildButton(context, Icons.restaurant, '식수',
                            '식수 QR, 식수신청 등', '/restaurant_main'),
                        buildButton(context, Icons.cut, '미용실', '미용실 예약, 가격표',
                            '/salon_main'),
                        buildButton(context, Icons.support_agent, '행정',
                            '공지사항, AS 요청 등', '/admin_main'),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text('오늘의 예약',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 15),
                    MiniRoundedBox(
                      iconData: Icons.schedule,
                      iconColor: Pallete.stateColor1,
                      text: '회의실 예약이 있습니다.',
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text('중요한 공지사항',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 15),
                    MiniRoundedBox(
                      iconData: Icons.support_agent,
                      iconColor: Pallete.stateColor1,
                      text: '퇴관 원서 작성 시 참고',
                    ),
                    SizedBox(height: 25)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
