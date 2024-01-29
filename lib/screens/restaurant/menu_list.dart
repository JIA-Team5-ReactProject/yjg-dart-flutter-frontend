import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// 메뉴 리스트를 위한 StatefulWidget 선언
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
  List<String>? _selectedMenu;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('식단표'), // 앱바 제목
      ),
      body: Column(
        children: [
          Container(
            //컨테이너 디자인(달력)
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(255, 241, 240, 240)),
              borderRadius: BorderRadius.circular(15.0),
            ),

            child: TableCalendar(
              locale: 'ko-KR', //달력 언어 한국어로
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
                leftChevronVisible: false, // 왼쪽 화살표 버튼 숨깁.
                rightChevronVisible: false, // 오른쪽 화살표 버튼 숨깁.
                headerMargin: EdgeInsets.only(left: 20),
              ),

              //날짜가 클릭 됐을 때 실행되는 것
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                  _selectedDay = selectedDay;
                  _selectedMenu = [
                    breakfastMenu[_selectedDay!.day % breakfastMenu.length],
                    lunchMenu[_selectedDay!.day % lunchMenu.length],
                    dinnerMenu[_selectedDay!.day % dinnerMenu.length]
                  ];
                });
              },
            ),
          ),
          menuCard()
        ],
      ),
    );
  }

//음식 메뉴 리스트로 담아놓기 (하드코딩)
  List<String> breakfastMenu = ['안성탕면', '김치', '콩밥'];
  List<String> lunchMenu = ['신라면', '파김치', '현미밥'];
  List<String> dinnerMenu = ['진라면(순)', '총각김치', '치자밥'];

//날짜 클릭 이벤트 위젯
  Widget menuCard() {
    if (_selectedDay == null) {
      return SizedBox.shrink(); // _selectedDay가 null이면 아무것도 표시하지 않음
    } else {
      return Material(
          elevation: 5.0, 
          child: Container(
            width: 380,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Color.fromARGB(255, 139, 139, 139),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 25, top: 10),
                    child: Text(
                      DateFormat('yyyy-MM-dd')
                          .format(_selectedDay!), // 선택된 날짜를 yyyy-MM-dd 형식으로 표시
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 가로방향으로 중앙에 정렬
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // 세로방향으로 중앙에 정렬
                        children: [
                          const Text(
                            "조식",
                            style: TextStyle(
                                color: Color.fromARGB(255, 29, 127, 159),
                                fontWeight: FontWeight.bold,fontSize: 20),
                                
                          ),
                          ...breakfastMenu
                              .map((menu) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(menu),
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // 세로방향으로 중앙에 정렬
                        children: [
                          const Text(
                            "중식",
                            style: TextStyle(
                                color: Color.fromARGB(255, 29, 127, 159),
                                fontWeight: FontWeight.bold,fontSize: 20),
                          ),
                          ...lunchMenu
                              .map((menu) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(menu),
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // 세로방향으로 중앙에 정렬
                        children: [
                          const Text(
                            "석식",
                            style: TextStyle(
                                color: Color.fromARGB(255, 29, 127, 159),
                                fontWeight: FontWeight.bold,fontSize: 20),
                          ),
                          ...dinnerMenu
                              .map((menu) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(menu),
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ));
    }
  }
}
