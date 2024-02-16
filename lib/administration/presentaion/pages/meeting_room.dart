import 'package:flutter/material.dart';
import 'package:yjg/administration/presentaion/widget/meeting_room_card.dart';
import 'package:yjg/administration/presentaion/widget/meeting_room_time.dart';
import 'package:yjg/shared/widgets/CustomSingleChildScrollView.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yjg/shared/widgets/white_main_rounded_box.dart';


class MeetingRoom extends StatefulWidget {
  const MeetingRoom({super.key});

  @override
  State<MeetingRoom> createState() => _MeetingRoomState();
}

class _MeetingRoomState extends State<MeetingRoom> {
  //현재 선택 된 룸 번호
  var selected_room = '';

  //월의 첫 날 계산 함수
  DateTime _firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month);
  }

  //월의 마지막 날 계산 함수
  DateTime _lastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1).subtract(Duration(days: 1));
  }

  DateTime _focusedDay = DateTime.now(); //달력에 포커스 되는 날짜
  DateTime? _selectedDay; //선택 된 날짜
  bool _isDaySelected = false; //날짜가 선택 되어 있는지 표시하는 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: "회의실 예약"),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      drawer: const Drawer(),
      body: CustomSingleChildScrollView(
        child: Column(
          children: [
            //겹쳐진 박스
            SizedBox(
              height: 150.0,
              child: Stack(
                children: [
                  BlueMainRoundedBox(),
                  Positioned(
                    top: 15,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: WhiteMainRoundedBox(
                        iconData: Icons.headset_mic,
                        mainText: '예약중인 회의실이 없습니다.',
                        secondaryText: '예약이 완료되면 예약 정보가 뜹니다.',
                        actionText: '',
                        timeText: '',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //예약 날짜 선택 글자
            Container(
              child: Text(
                '예약 날짜 선택',
                style: TextStyle(fontSize: 20),
              ),
            ),

            //달력
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
                    _isDaySelected = true;
                  });
                },
              ),
            ),

            //회의실 선택 글자
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    '회의실 선택',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  child: Text(
                    selected_room,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue), // 선택된 회의실을 강조하기 위해 파란색으로 설정
                  ),
                ),
              ],
            ),

            //회의실 목록 버튼
            if (_isDaySelected == true)
              Container(
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_room = '201호';
                        });
                      },
                      child: MeetingRoomCard(room: true, roomNumber: '201호'),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_room = '202호';
                        });
                      },
                      child: MeetingRoomCard(room: true, roomNumber: '202호'),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_room = '203호';
                          print(selected_room);
                        });
                      },
                      child: MeetingRoomCard(room: true, roomNumber: '203호'),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                        
                        });
                      },
                      child: MeetingRoomCard(room: false, roomNumber: '204호'),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected_room = '205호';
                        });
                      },
                      child: MeetingRoomCard(room: true, roomNumber: '205호'),
                    ),
                  ],
                ),
              ),

            //예약 시간 선택 글자
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    '예약 시간 선택',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),

            //시간 선택 버튼
            if (selected_room != '')
              MeetingRoomTime(
                booking_time: false,
              ),
              
            // 예약 완료 버튼
            Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white)
                ),
                child: Text("예약 하기"),
                onPressed: () {
                  // 버튼을 눌렀을 때 Alert 창.
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("예약이 완료 되었습니다.",style: TextStyle(color: Colors.black),),
                        content: Text(
                          "날짜: ${_selectedDay== null ? '' : '${_selectedDay!.year}-${_selectedDay!.month}-${_selectedDay!.day}'}\n" +
                              "호실: $selected_room\n" +
                              "시간대: ${selectedTimes.join(', ')}", // 선택된 시간대를 콤마로 구분하여 표시합니다.
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text("확인"),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/admin_main');
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  
}
