import "package:flutter/material.dart";
import 'package:yjg/salon/presentaion/widgets/alert_button.dart';
import 'package:yjg/salon/presentaion/widgets/booking_next_button.dart';
import 'package:yjg/salon/presentaion/widgets/service_tabbar.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';

class BookingServiceSelect extends StatelessWidget {
  const BookingServiceSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: '서비스 선택'),
      drawer: BaseDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: SingleChildScrollView(
        // 여기에 SingleChildScrollView 추가
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '서비스를 선택해주세요.',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  ServiceTabBar(),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AlertButton(),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
