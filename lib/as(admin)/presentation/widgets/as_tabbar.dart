import 'package:flutter/material.dart';
import 'package:yjg/shared/theme/theme.dart';

class AsTabBar extends StatelessWidget {
  final List<Tab> tabs = const <Tab>[
    Tab(text: '미처리'),
    Tab(text: '처리완료'),
  ];

  const AsTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.0),
        topRight: Radius.circular(30.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          TabBar(
            tabs: tabs,
            tabAlignment: TabAlignment.center,
            labelColor: Palette.mainColor,
            unselectedLabelColor: Palette.stateColor4,
            labelStyle: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
            labelPadding: EdgeInsets.only(right: 15.0, left: 15.0, top: 15.0),
            indicatorColor: Palette.mainColor.withOpacity(0.0),
            dividerColor: Colors.transparent,
            indicatorWeight: 1,
            isScrollable: true,
          ),
          
        ],
      ),
    );
  }
}
