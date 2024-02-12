import 'package:flutter/material.dart';
import 'package:yjg/bus/presentaion/widgets/bus_timetable.dart';
import 'package:yjg/shared/theme/theme.dart';

class BusTabBar extends StatelessWidget {
  final List<Tab> tabs = const <Tab>[
    Tab(text: '전체'),
    Tab(text: '평일'),
    Tab(text: '주말'),
  ];

  const BusTabBar({Key? key}) : super(key: key);

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
          Expanded(
            child: TabBarView(
              children: tabs.map((Tab tab) {
                String selectedRoute = tab.text == '전체' ? '전체' : tab.text!;
                return BusTimetable(selectedRoute: selectedRoute);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
