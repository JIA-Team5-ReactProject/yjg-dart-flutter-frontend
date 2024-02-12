import 'package:flutter/material.dart';
import 'package:yjg/bus/presentaion/widgets/bus_tabbar.dart';
import 'package:yjg/shared/theme/theme.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';

class BusSchedule extends StatelessWidget {
  const BusSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        appBar: const BaseAppBar(title: '버스 시간표'),
        drawer: const BaseDrawer(),
        bottomNavigationBar: const CustomBottomNavigationBar(),
        body: Stack(
          children: <Widget>[
            Container(
              color: Palette.mainColor, 
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: const BusTabBar(), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
