import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/dashboard/presentaion/viewmodels/urgent_viewmodel.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';
import 'package:yjg/shared/widgets/mini_rounded_box.dart';
import 'package:yjg/dashboard/presentaion/widgets/rounded_box.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:yjg/shared/widgets/move_button.dart';

class DashboardMain extends ConsumerWidget {
  const DashboardMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // notice 상태 감시
    final asyncNotice = ref.watch(urgentNoticeProvider);

    // 화면의 가로 길이
    final screenWidth = MediaQuery.of(context).size.width;
    // 버튼의 가로 길이
    final buttonWidth = (screenWidth - 90) / 2;
    // 세로 길이 설정
    final buttonHeight = buttonWidth * 1.05;

    return Scaffold(
      appBar: const BaseAppBar(),
      drawer: BaseDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: CustomSingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: buttonHeight * 2.5 + 100, // 버튼 두 개의 세로 길이 합산 + 간격
              child: Stack(
                children: <Widget>[
                  RoundedBox(),
                  Positioned(
                    top: 140,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      child: SizedBox(
                        child: GridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2, // 한 줄에 2개씩 배치
                          mainAxisSpacing: 20.0,
                          crossAxisSpacing: 15.0,
                          childAspectRatio:
                              buttonWidth / buttonHeight, // 가로*세로 비율 조정
                          children: <Widget>[
                            MoveButton(
                                icon: Icons.directions_bus,
                                text1:
                                    'mainDashboard.navigation.bus.title'.tr(),
                                text2:
                                    'mainDashboard.navigation.bus.description'
                                        .tr(),
                                route: '/bus_main'),
                            MoveButton(
                                icon: Icons.restaurant,
                                text1:
                                    'mainDashboard.navigation.restaurant.title'
                                        .tr(),
                                text2:
                                    'mainDashboard.navigation.restaurant.description'
                                        .tr(),
                                route: '/restaurant_main'),
                            MoveButton(
                                icon: Icons.cut,
                                text1:
                                    'mainDashboard.navigation.salon.title'.tr(),
                                text2:
                                    'mainDashboard.navigation.salon.description'
                                        .tr(),
                                route: '/salon_main'),
                            MoveButton(
                                icon: Icons.support_agent,
                                text1:
                                    'mainDashboard.navigation.administration.title'
                                        .tr(),
                                text2:
                                    'mainDashboard.navigation.administration.description'
                                        .tr(),
                                route: '/admin_main'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Navigator.pushNamed(context, '/notice');
                  },
                  child: asyncNotice.when(
                    data: (notice) => MiniRoundedBox(
                      iconData: Icons.support_agent,
                      iconColor: Palette.stateColor1,
                      text: notice.title,
                    ),
                    loading: () => Center(
                        child: CircularProgressIndicator(
                            color: Palette.stateColor4)),
                    error: (e, _) => Text('Error: $e'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
