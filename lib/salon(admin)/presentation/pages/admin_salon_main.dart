import "package:flutter/material.dart";
import "package:yjg/salon(admin)/presentation/widgets/main_rounded_box.dart";
import "package:yjg/salon(admin)/presentation/widgets/main_rounded_box_s.dart";
import "package:yjg/shared/theme/palette.dart";
import "package:yjg/shared/widgets/CustomSingleChildScrollView.dart";
import "package:yjg/shared/widgets/base_appbar.dart";
import "package:yjg/shared/widgets/blue_main_rounded_box.dart";
import "package:yjg/shared/widgets/bottom_navigation_bar.dart";
import "package:yjg/shared/widgets/move_button.dart";

class AdminSalonMain extends StatelessWidget {
  const AdminSalonMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: "미용실"),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: CustomSingleChildScrollView(
        child: Column(
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
                      child: MainRoundedBox(
                        iconData: Icons.cut,
                        mainText: '금일 확정 예약',
                        actionText: '자세히 보기',
                        bookText: '12건',
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
                '미용실 관리',
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
                    route: '/admin_salon_booking'),
                MoveButton(
                    icon: Icons.content_paste_search,
                    text1: '가격표',
                    text2: '미용실 이용 가격 안내',
                    route: '/admin_salon_price_list'),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 40),
                  child: const Text(
                    '미승인 예약(최근 3건)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 20.0, top: 5.0),
                  child: TextButton(
                    onPressed: () => {
                      Navigator.pushNamed(context, '/admin_salon_booking'),},
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                        Palette.stateColor4.withOpacity(0.1),
                      ),
                    ),
                    child: const Text(
                      "더보기",
                      style: TextStyle(
                          color: Palette.stateColor4,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.2),
                    ),
                  ),
                ),
              ],
            ),

            // TODO: 하드 코딩(일단 3건만 볼 수 있도록 하기)
            for (int i = 0; i < 3; i++)
              MainRoundedBoxSmall(
                  iconData: Icons.cut,
                  bookText: "고속도로컷",
                  time: "24/02/15 16시",
                  iconColor: Palette.stateColor1),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
