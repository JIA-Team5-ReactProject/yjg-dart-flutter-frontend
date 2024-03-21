import 'package:flutter/material.dart';
import 'package:yjg/shared/theme/theme.dart';

class AsTabBar extends StatelessWidget {
  final TabController controller; // TabController 타입의 controller 매개변수 추가
  final List<Tab> tabs = const <Tab>[
    Tab(text: '미처리'),
    Tab(text: '처리완료'),
  ];

  // 생성자에 controller 매개변수를 추가
  const AsTabBar({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        tabBarTheme: TabBarTheme(
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Palette.mainColor, width: 2.0),
            ),
          ),
        ),
      ),
      child: Material(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            TabBar(
              controller: controller,
              tabs: tabs,
              labelColor: Palette.mainColor,
              unselectedLabelColor: Palette.stateColor4,
              labelStyle: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
              labelPadding: EdgeInsets.only(right: 15.0, left: 15.0, top: 15.0),
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              isScrollable: false,
            ),
          ],
        ),
      ),
    );
  }
}
