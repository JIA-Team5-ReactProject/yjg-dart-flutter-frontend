import 'package:flutter/material.dart';
import 'package:yjg/widgets/base_appbar.dart';
import 'package:yjg/widgets/base_drawer.dart';
import 'package:yjg/widgets/bottom_navigation_bar.dart';
import 'package:yjg/widgets/move_button.dart';

//임의 나중에 제거
var person = 7;

class RestaurantMain extends StatefulWidget {
  const RestaurantMain({super.key});

  @override
  State<RestaurantMain> createState() => _RestaurantMainState();
}

class _RestaurantMainState extends State<RestaurantMain> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: '식수'),
      drawer: const BaseDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //조,중,석식 메뉴 표시 DB연동 필요
            Container(
              height: 200.0,
              color: Color.fromARGB(255, 29, 127, 159),
              child: ListView(
                scrollDirection: Axis.horizontal, // 가로로 스크롤
                children: <Widget>[
                  mealCard('오늘 조식', ['신라면', '김치']),
                  mealCard('오늘 중식', ['안성탕면', '김치']),
                  mealCard('오늘 석식', ['진라면(매)', '김치']),
                ],
              ),
            ),

            //식수 이용하기 글자
            Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment(-0.85, 0.2),
              child: const Text(
                '식수 이용하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            //이동 버튼 배치
            const Wrap(
              spacing: 30, // 아이템들 사이의 가로 간격
              runSpacing: 30, // 아이템들 사이의 세로 간격
              children: <Widget>[
                MoveButton(icon: Icons.backup_table, text1: '식단표', text2: '이번 일주일 식단표', route: '/menu_list'),
                MoveButton(icon: Icons.qr_code, text1: '식수 QR', text2: '식사 시 QR 찍기', route: '/meal_qr'),
                MoveButton(icon: Icons.calendar_month_outlined, text1: '주말 식수', text2: '주말 식수 신청', route: '/weekend_meal'),
                MoveButton(icon: Icons.assignment_turned_in_outlined, text1: '식수 신청', text2: '식사 신청', route: '/meal_application'),
              ],
            ),

            //현재 주말 식수 신청 인원 현황 수
            Container(
              height: 60,
              width: 330,
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color.fromARGB(255, 139, 139, 139),
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.group,size: 40,color: Color.fromARGB(255, 29, 127, 159),),
                  ), // 왼쪽 아이콘
                  SizedBox(width: 10), // 아이콘과 텍스트 사이의 간격
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('현재 주말식수 신청 인원'), // 중간 텍스트
                      Text(
                        '토요일: $person명 | 일요일 $person명', // 아래 텍스트
                        style: TextStyle(color: Color.fromARGB(255, 29, 127, 159),),
                      ),
                    ],
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

//조식, 중식, 석식 메뉴 위젯
Widget mealCard(String meal, List<String> menu) {
  return Container(
    width: 150.0,
    margin: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Text(meal,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 29, 127, 159),
              )),
          const SizedBox(height: 5),
          Column(children: menu.map((item) => Text(item)).toList()),
        ],
      ),
    ),
  );
}