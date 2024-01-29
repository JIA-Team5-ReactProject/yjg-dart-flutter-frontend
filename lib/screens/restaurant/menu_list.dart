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
  DateTime? _selectedDay; // 사용자가 선택한 날짜

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
    //           boxShadow: [
    //   BoxShadow(
    //     color: Colors.grey.withOpacity(0.5), // 그림자의 색상 설정
    //     spreadRadius: 5, // 그림자가 퍼지는 정도 설정
    //     blurRadius: 7, // 그림자의 흐림 정도 설정
    //     offset: Offset(0, 3), // 그림자의 위치 조정
    //   ),
    // ],
            ),

            child: TableCalendar(
              firstDay: _firstDayOfMonth(DateTime.now()), // 캘린더의 첫번째 날짜
              lastDay: _lastDayOfMonth(DateTime.now()), // 캘린더의 마지막 날짜
              focusedDay: DateTime.now(), // 초기 포커스 되는 날짜
              //보이는 형식을 월만 허용하게 해서 보이는 형식 바꾸는 버튼 삭제
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month'
              }, // 캘린더 형식
              selectedDayPredicate: (day) {
                // 선택된 날짜를 결정하는 함수
                return isSameDay(_selectedDay, day); // 선택된 날짜와 같은 날인지 확인
              },
              onDaySelected: (selectedDay, focusedDay) {
                // 날짜가 선택되었을 때의 콜백 함수
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // 선택된 날짜가 업데이트 되었을 때만 setState 호출
                  setState(
                    () {
                      _selectedDay = selectedDay;
                    },
                  );
                }
              },
              headerStyle: const HeaderStyle(
                  leftChevronVisible: false, // 왼쪽 화살표 버튼 숨깁.
                  rightChevronVisible: false, // 오른쪽 화살표 버튼 숨깁.
                  headerMargin: EdgeInsets.only(left: 20)),
            ),
          ),
          if (_selectedDay != null)
            // 선택된 날짜가 있을 때만 메뉴 카드를 보여줌
            menuCard(_selectedDay!),
        ],
      ),
    );
  }

  //날짜 클릭 시 조,중,석 메뉴 보여주는 위젯카드
  Widget menuCard(DateTime date) {
    // 선택한 날짜를 yyyy-mm-dd 형식의 문자열로 변환
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    return Container(
      width: MediaQuery.of(context).size.width, // 메뉴 카드 너비 설정
      margin: EdgeInsets.all(7),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _selectedDay =
                      null; // 'x' 버튼을 누르면 선택된 날짜를 null로 설정하여 메뉴 카드를 숨김
                });
              },
            ),
          ),
          Text(formattedDate,
            style:
              const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),

          const SizedBox(height: 16.0),
          const Text('조식',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          const Text('안성탕면, 김치, 콩밥'),

          const SizedBox(height: 8.0),
          const Text('중식',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          const Text('신라면, 파김치, 현미밥'),

          const SizedBox(height: 8.0),
          const Text('석식',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          const Text('진라면(순), 총각김치, 치자밥'),
        ],
      ),
    );
  }
}
