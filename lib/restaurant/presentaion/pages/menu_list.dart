import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yjg/restaurant/data/data_sources/menu_data_source.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';

class MenuList extends StatefulWidget {
  @override
  _MenuListState createState() => _MenuListState();
}

//월의 첫 날 계산 함수
DateTime _firstDayOfMonth(DateTime date) {
  return DateTime(date.year, date.month);
}

//월의 마지막 날 계산 함수
DateTime _lastDayOfMonth(DateTime date) {
  return DateTime(date.year, date.month + 1).subtract(Duration(days: 1));
}

class _MenuListState extends State<MenuList> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final _menuDataSource = MenuDataSource();

  final storage = FlutterSecureStorage(); //토큰 함수

  // * 해당 날짜의 식단표를 불러오는 API 함수
  Future<void> fetchMenus(DateTime selectedDay) async {
    try {
      final response = await _menuDataSource.fetchSelectedDayMenus(selectedDay);
      final data = response.data['month_menus'];

      if (data.isEmpty) {
        // API에서 가져온 리스트가 비어있을 경우 기본 메시지를 설정
        setState(() {
          breakfastMenu = [
            ' ',
            'restaurant.todaymenu.nomenu.1'.tr(),
            'restaurant.todaymenu.nomenu.2'.tr(),
            'restaurant.todaymenu.nomenu.3'.tr()
          ];
          lunchMenu = [
            ' ',
            'restaurant.todaymenu.nomenu.1'.tr(),
            'restaurant.todaymenu.nomenu.2'.tr(),
            'restaurant.todaymenu.nomenu.3'.tr()
          ];
          dinnerMenu = [
            ' ',
            'restaurant.todaymenu.nomenu.1'.tr(),
            'restaurant.todaymenu.nomenu.2'.tr(),
            'restaurant.todaymenu.nomenu.3'.tr()
          ];
        });
      } else {
        List<String> newBreakfastMenu = [];
        List<String> newLunchMenu = [];
        List<String> newDinnerMenu = [];

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
          breakfastMenu = newBreakfastMenu;
          lunchMenu = newLunchMenu;
          dinnerMenu = newDinnerMenu;
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('식단표를 불러오지 못했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: 'restaurant.title.0.2'.tr()),
      drawer: BaseDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: SingleChildScrollView(
        // 스크롤 가능한 구조로 변경
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              //컨테이너 디자인(달력)
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 241, 240, 240)),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: TableCalendar(
                locale: 'ja-JP', //달력 언어 일본어로
                //locale: context.locale.toLanguageTag(), //시스템 언어에 따른 달력 언어 설정
                firstDay: _firstDayOfMonth(DateTime.now()), // 캘린더의 첫번째 날짜
                lastDay: _lastDayOfMonth(DateTime.now()), // 캘린더의 마지막 날짜
                focusedDay: DateTime.now(), // 초기 포커스 되는 날짜

                // 선택된 날짜를 결정하는 설정 추가
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },

                //보이는 형식을 월만 허용하게 해서 보이는 형식 바꾸는 버튼 삭제
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},

                headerStyle: const HeaderStyle(
                  leftChevronVisible: false, // 왼쪽 화살표 버튼 숨김
                  rightChevronVisible: false, // 오른쪽 화살표 버튼 숨김
                  headerMargin: EdgeInsets.only(left: 20),
                ),

                //날짜가 클릭 됐을 때 실행되는 것
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                    _selectedDay = selectedDay;
                    fetchMenus(selectedDay); // API 호출 함수 실행
                  });
                },
              ),
            ),

            menuCardContainer(), // 메뉴 카드를 표시하는 컨테이너
          ],
        ),
      ),
    );
  }

//음식 메뉴 리스트로 담아놓기
  List<String> breakfastMenu = [];
  List<String> lunchMenu = [];
  List<String> dinnerMenu = [];

  Widget menuCardContainer() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: 16), // 시작 여백
            menuCard(),
            SizedBox(width: 16), // 끝 여백
          ],
        ),
      ),
    );
  }

//날짜 클릭 이벤트 위젯
  Widget menuCard() {
    if (_selectedDay == null) {
      return SizedBox.shrink(); // _selectedDay가 null이면 아무것도 표시하지 않음
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                DateFormat('yyyy年 MM月 dd日').format(_selectedDay!), // 선택된 날짜 표시
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            height: 230, // 메뉴 카드의 높이를 고정합니다.
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                menuSection('restaurant.todaymenu.1'.tr(), breakfastMenu),
                SizedBox(width: 100),
                menuSection('restaurant.todaymenu.2'.tr(), lunchMenu),
                SizedBox(width: 100),
                menuSection('restaurant.todaymenu.3'.tr(), dinnerMenu),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget menuSection(String title, List<String> menuItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: menuItems
              .map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(item),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
