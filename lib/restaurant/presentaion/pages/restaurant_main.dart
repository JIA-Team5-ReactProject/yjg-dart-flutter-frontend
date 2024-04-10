import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/restaurant/data/data_sources/meal_reservation_data_source.dart';
import 'package:yjg/restaurant/data/data_sources/menu_data_source.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:yjg/shared/widgets/move_button.dart';

//현재 신청 인원
int satPerson = 0;
int sunPerson = 0;

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
  final _reservationDataSource = MealReservationDataSource();
  final _menuDataSource = MenuDataSource();
  @override
  void initState() {
    super.initState();
    _fetchMenus(); // 위젯 초기화 시 오늘 식단표 불러오기
    _fetchWeekendApplicationCounts(); // 위젯 초기화 시 주말 식수 인원 불러오기
  }

  final storage = FlutterSecureStorage(); // 토큰 함수 (정원)

  // * 오늘 식단표 불러오는 GET API 호출
  Future<void> _fetchMenus() async {
    try {
      final response = await _menuDataSource.fetchMenus();

      final data = response.data['month_menus'];
      debugPrint('메뉴 데이터: $data');
      debugPrint(DateTime.now().toString());

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
        breakfastMenu = newBreakfastMenu.isNotEmpty
            ? newBreakfastMenu
            : [' ', '등록 된', '메뉴가', '없습니다.'];
        lunchMenu = newLunchMenu.isNotEmpty
            ? newLunchMenu
            : [' ', '등록 된', '메뉴가', '없습니다.'];
        dinnerMenu = newDinnerMenu.isNotEmpty
            ? newDinnerMenu
            : [' ', '등록 된', '메뉴가', '없습니다.'];
      }); // 데이터를 가져왔으므로 UI 갱신
    } catch (e) {
      debugPrint('오류 발생: $e');
    }
  }

  // * 주말식수 신청 인원 불러오는 GET API 호출
  Future<void> _fetchWeekendApplicationCounts() async {
    try {
      // 토요일 신청 인원 수 가져오기
      final dataSat =
          await _reservationDataSource.fetchSatApplicationCounts('sat');
      // 일요일 신청 인원 수 가져오기
      final dataSun =
          await _reservationDataSource.fetchSatApplicationCounts('sun');

      setState(() {
        satPerson = dataSat.data['satCount'];
        sunPerson = dataSun.data['sunCount'];
      });
    } catch (e) {
      debugPrint('오류 발생: $e');
    }
  }

  // API 값에 따라 주말 식수버튼 클릭 가능하게 하는 버튼
  Widget conditionalMoveButton() {
    return FutureBuilder<bool>(
      future: _reservationDataSource.fetchWeekendApplyState(),
      builder: (context, snapshot) {
        if (snapshot.hasError) { //에러 코드를 반환하는 경우
          return Opacity(
            opacity: false ? 1.0 : 0.5,
            child: IgnorePointer(
              ignoring: !false,
              child: MoveButton(
                icon: Icons.calendar_month_outlined,
                text1: '주말 식수',
                text2: '월~수 신청가능',
                route: '/weekend_meal',
              ),
            ),
          );
        } else {
          // API로부터 받은 값과 요일을 기준으로 버튼 활성화 결정
          final isButtonActive = snapshot.data == true;

          return Opacity(
            opacity: isButtonActive ? 1.0 : 0.5,
            child: IgnorePointer(
              ignoring: !isButtonActive,
              child: MoveButton(
                icon: Icons.calendar_month_outlined,
                text1: '주말 식수',
                text2: '월~수 신청가능',
                route: '/weekend_meal',
              ),
            ),
          );
        }
      },
    );
  }

  // API 값에 따라 학기 식수버튼 클릭 가능하게 하는 버튼
  Widget semesterMoveButton() {
    return FutureBuilder<bool>(
      future: _reservationDataSource.fetchSemesterApplyState(),
      builder: (context, snapshot) {
        if (snapshot.hasError) { //에러 코드를 반환하는 경우
          return Opacity(
            opacity: false ? 1.0 : 0.5,
            child: IgnorePointer(
              ignoring: !false,
              child: MoveButton(
                icon: Icons.calendar_month_outlined,
                text1: '학기 식수',
                text2: '학기 식수 신청',
                route: '/meal_application',
              ),
            ),
          ); 
        } else {
          // API로부터 받은 값을 기준으로 버튼 활성화 결정
          final isButtonActive = snapshot.data == true;

          return Opacity(
            opacity: isButtonActive ? 1.0 : 0.5,
            child: IgnorePointer(
              ignoring: !isButtonActive,
              child: MoveButton(
                icon: Icons.calendar_month_outlined,
                text1: '학기 식수',
                text2: '학기 식수 신청',
                route: '/meal_application',
              ),
            ),
          );
        }
      },
    );
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
            Wrap(
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
                conditionalMoveButton(),
                semesterMoveButton(),
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
                        '토요일: $satPerson명 | 일요일 $sunPerson명', // 아래 텍스트
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
