import 'package:flutter/material.dart';
import 'package:yjg/shared/widgets/as_card.dart';
import 'package:yjg/as(admin)/presentation/widgets/as_tabbar.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';

class AsMain extends StatelessWidget {
  const AsMain({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const BaseAppBar(title: 'AS관리'),
        bottomNavigationBar: const CustomBottomNavigationBar(),
        body: Column(
          children: [
            const AsTabBar(),
            SizedBox(height: 10.0),
            Text(
              '게시글을 누르면 상세보기로 이동합니다.',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30.0),
            Expanded(
              child: TabBarView(
                
                children: [
                  // 미처리 탭의 내용
                  CustomSingleChildScrollView(
                    child: Column(
                      children: [
                        AsCard(state: 2, title: '변기가 막혔어요..', day: '2024-02-15'),
                        AsCard(state: 3, title: '전등이 안 켜져요', day: '2024-02-14'),
                        AsCard(state: 2, title: '변기가 막혔어요..', day: '2024-02-15'),
                        AsCard(state: 3, title: '전등이 안 켜져요', day: '2024-02-14'),
                        AsCard(state: 2, title: '변기가 막혔어요..', day: '2024-02-15'),
                        AsCard(state: 3, title: '전등이 안 켜져요', day: '2024-02-14'),
                      ],
                    ),
                  ),
                  // 처리완료 탭의 내용
                  CustomSingleChildScrollView(
                    child: Column(
                      children: [
                        AsCard(state: 1, title: '변기 막힘', day: '2024-02-13'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
