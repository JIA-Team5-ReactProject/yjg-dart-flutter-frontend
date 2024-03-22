import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:yjg/shared/widgets/move_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//임의 나중에 제거
var person = 7;

//음식 메뉴 리스트로 담아놓기
List<String> breakfastMenu = [];
List<String> lunchMenu = [];
List<String> dinnerMenu = [];

class RestaurantMain extends StatefulWidget {
  const RestaurantMain({super.key});

  @override
  State<RestaurantMain> createState() => _RestaurantMainState();
}

class _RestaurantMainState extends State<RestaurantMain> {
  final storage = FlutterSecureStorage(); // 토큰 함수 (정원)

  @override
  void initState() {
    super.initState();
    _fetchMenus();
  }

  Future<String?> _getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<void> _fetchMenus() async {
  try {
    final token = await _getToken(); // 토큰 가져오기
    if (token != null) {
      final formattedDate = DateTime.now().toIso8601String().substring(0, 10); // 시간 제외하고 날짜만 가져옴
      final response = await http.get(
        Uri.parse('$apiURL/api/restaurant/menu/get/d?date=$formattedDate'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('메뉴 가져오기 성공');
        final data = json.decode(response.body)['month_menus'];
        print('메뉴 데이터: $data');
        print(DateTime.now().toString());
        List<String> newBreakfastMenu = [];
        List<String> newLunchMenu = [];
        List<String> newDinnerMenu = [];

        // 기존 데이터 초기화
        breakfastMenu.clear();
        lunchMenu.clear();
        dinnerMenu.clear();

        for (var item in data) {
          final String mealTime = item['meal_time'];
          final List<String> menuItems = (item['menu'] as String)
              .split(' ')
              .where((s) => s.isNotEmpty)
              .toList();
          switch (mealTime) {
            case 'b':
              newBreakfastMenu.addAll(menuItems);
              break;
            case 'l':
              newLunchMenu.addAll(menuItems);
              break;
            case 'd':
              newDinnerMenu.addAll(menuItems);
              break;
          }
        }

        setState(() {
          breakfastMenu = newBreakfastMenu.isNotEmpty ? newBreakfastMenu : [' ','등록 된','메뉴가','없습니다.'];
          lunchMenu = newLunchMenu.isNotEmpty ? newLunchMenu : [' ','등록 된','메뉴가','없습니다.'];
          dinnerMenu = newDinnerMenu.isNotEmpty ? newDinnerMenu : [' ','등록 된','메뉴가','없습니다.'];
        }); // 데이터를 가져왔으므로 UI 갱신
      } else {
        print('메뉴 가져오기 실패');
        throw Exception('Failed to load menus');
      }
    } else {
      print('토큰 없음');
      throw Exception('Token not found'); // 토큰이 없으면 예외 처리
    }
  } catch (e) {
    print('오류 발생: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: '식수'),
      drawer: BaseDrawer(),
      body: CustomSingleChildScrollView(
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
                  mealCard('오늘 조식', breakfastMenu),
                  mealCard('오늘 중식', lunchMenu),
                  mealCard('오늘 석식', dinnerMenu),
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
                MoveButton(
                    icon: Icons.backup_table,
                    text1: '식단표',
                    text2: '이번 일주일 식단표',
                    route: '/menu_list'),
                MoveButton(
                    icon: Icons.qr_code,
                    text1: '식수 QR',
                    text2: '식사 시 QR 찍기',
                    route: '/meal_qr'),
                MoveButton(
                    icon: Icons.calendar_month_outlined,
                    text1: '주말 식수',
                    text2: '주말 식수 신청',
                    route: '/weekend_meal'),
                MoveButton(
                    icon: Icons.assignment_turned_in_outlined,
                    text1: '식수 신청',
                    text2: '식사 신청',
                    route: '/meal_application'),
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
                    child: Icon(
                      Icons.group,
                      size: 40,
                      color: Color.fromARGB(255, 29, 127, 159),
                    ),
                  ), // 왼쪽 아이콘
                  SizedBox(width: 10), // 아이콘과 텍스트 사이의 간격
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('현재 주말식수 신청 인원'), // 중간 텍스트
                      Text(
                        '토요일: $person명 | 일요일 $person명', // 아래 텍스트
                        style: TextStyle(
                          color: Color.fromARGB(255, 29, 127, 159),
                        ),
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
