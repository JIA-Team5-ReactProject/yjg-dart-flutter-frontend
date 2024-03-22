import 'package:flutter/material.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';
import 'package:yjg/shared/widgets/mini_rounded_box.dart';
import 'package:yjg/dashboard/presentaion/widgets/rounded_box.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:yjg/shared/widgets/move_button.dart';

class DashboardMain extends StatelessWidget {
  const DashboardMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(),
      drawer: BaseDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: CustomSingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 540, // Stack의 높이를 조정(Stack은 자식 요소로 크기 결정되므로 크기 조정해줘야 함)
              child: Stack(
                children: <Widget>[
                  RoundedBox(),
                  Positioned(
                    top: 140,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 30,
                        runSpacing: 30,
                        children: <Widget>[
                          MoveButton(
                              icon: Icons.directions_bus,
                              text1: '버스',
                              text2: '버스 시간표, 버스 QR',
                              route: '/bus_main'),
                          MoveButton(
                              icon: Icons.restaurant,
                              text1: '식수',
                              text2: '식수 QR, 식수신청 등',
                              route: '/restaurant_main'),
                          MoveButton(
                              icon: Icons.cut,
                              text1: '미용실',
                              text2: '미용실 예약, 가격표',
                              route: '/salon_main'),
                          MoveButton(
                              icon: Icons.support_agent,
                              text1: '행정',
                              text2: '공지사항, AS 요청 등',
                              route: '/admin_main'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                MiniRoundedBox(
                  iconData: Icons.support_agent,
                  iconColor: Palette.stateColor1,
                  text: '퇴관 원서 작성 시 참고',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
