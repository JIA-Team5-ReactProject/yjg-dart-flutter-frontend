import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';
import 'package:yjg/shared/widgets/white_main_rounded_box.dart';

class MeetingRoomApp extends StatefulWidget {
  const MeetingRoomApp({Key? key}) : super(key: key);

  @override
  State<MeetingRoomApp> createState() => _MeetingRoomAppState();
}

class _MeetingRoomAppState extends State<MeetingRoomApp> {
  @override
  void initState() {
    super.initState();
    fetchMeetingRooms(); // 앱이 시작될 때 회의실 목록을 가져오는 함수 호출
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedRoom = '';
  List<String> _selectedTimes = [];
  List<String> _reservedTimes = [];
  List<String> _meetingRooms = []; //받아온 회의실 목록을 저장해주는 API

  String? _minSelectableTime; // 사용자가 선택할 수 있는 최소 시간을 저장하는 변수
  String? _maxSelectableTime; // 사용자가 선택할 수 있는 최대 시간을 저장하는 변수

  static final storage = FlutterSecureStorage(); //정원이가 말해준 코드(토큰)

  //해당 회의실 마다의 예약 된 시간 목록을 받아오는 API
  Future<void> fetchReservedTimes(String roomNumber, DateTime date) async {
    final token = await storage.read(key: 'auth_token'); //정원이가 말해준 코드(토큰 불러오기)

    final String dateString =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final numericRoomNumber =
        roomNumber.replaceAll(RegExp(r'[^0-9]'), ''); // 호실 번호에서 숫자 부분만 추출

    final response = await http.get(
      Uri.parse(
          '$apiURL/api/meeting-room/check?date=$dateString&room_number=$numericRoomNumber'),
      headers: {'Authorization': 'Bearer $token'}, // 요청 헤더에 토큰 추가
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _reservedTimes = List<String>.from(data['reservations']);
        _maxSelectableTime = null; // 새로운 호실을 선택할 때는 최대 선택 가능 시간을 리셋합니다.
      });
    } else {
      setState(() {
        _reservedTimes = [];
        _maxSelectableTime = null;
      });
    }
  }

  //회의실의 목록을 받아오는 API
  Future<void> fetchMeetingRooms() async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('$apiURL/api/meeting-room'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final rooms = List<String>.from(
          data['meeting_rooms'].map((room) => room['room_number']));

      setState(() {
        _meetingRooms = rooms;
      });
    } else {
      // 에러 처리
      print('Failed to load meeting rooms');
    }
  }

  void _updateSelectableTimes(String selectedTime) {
    DateTime selectedDateTime = DateFormat.Hm().parse(selectedTime);

    if (!_selectedTimes.contains(selectedTime)) {
      // 선택한 시간을 추가
      _selectedTimes.add(selectedTime);
    } else {
      // 이미 선택된 시간을 제거
      _selectedTimes.remove(selectedTime);
    }

    // 선택된 시간을 시간 순으로 정렬
    _selectedTimes.sort(
        (a, b) => DateFormat.Hm().parse(a).compareTo(DateFormat.Hm().parse(b)));

    if (_selectedTimes.isNotEmpty) {
      // 선택된 시간 범위 내의 모든 시간을 선택
      List<String> newSelectedTimes = [];
      DateTime startTime = DateFormat.Hm().parse(_selectedTimes.first);
      DateTime endTime = DateFormat.Hm().parse(_selectedTimes.last);

      for (DateTime time = startTime;
          time.isBefore(endTime);
          time = time.add(Duration(hours: 1))) {
        String formattedTime = DateFormat.Hm().format(time);
        if (!_reservedTimes.contains(formattedTime)) {
          // 예약된 시간을 제외
          newSelectedTimes.add(formattedTime);
        }
      }

      // 종료 시간 추가
      String formattedEndTime = DateFormat.Hm().format(endTime);
      if (!_reservedTimes.contains(formattedEndTime)) {
        newSelectedTimes.add(formattedEndTime);
      }

      setState(() {
        _selectedTimes = newSelectedTimes;
      });
    }

    // 최소 및 최대 선택 가능 시간 업데이트
    _minSelectableTime =
        _selectedTimes.isNotEmpty ? _selectedTimes.first : null;
    _setMaxSelectableTime(
        _selectedTimes.isNotEmpty ? _selectedTimes.last : null);
  }

  void _setMaxSelectableTime(String? lastSelectedTime) {
    if (lastSelectedTime == null) {
      _maxSelectableTime = null;
      return;
    }

    DateTime lastTime = DateFormat.Hm().parse(lastSelectedTime);
    DateTime maxTime;

    // `_reservedTimes` 리스트를 순회하며 `lastTime` 이후의 가장 빠른 예약된 시간을 찾습니다.
    // 예약된 시간이 없다면, 최대 선택 가능 시간을 하루의 마지막 시간으로 설정합니다.
    final upcomingReservedTime = _reservedTimes
        .map((time) => DateFormat.Hm().parse(time))
        .where((time) => time.isAfter(lastTime))
        .toList();

    if (upcomingReservedTime.isNotEmpty) {
      upcomingReservedTime.sort();
      maxTime = upcomingReservedTime.first;
    } else {
      maxTime = DateFormat.Hm().parse("23:59");
    }

    setState(() {
      _maxSelectableTime = DateFormat.Hm().format(maxTime);
    });
  }

  // 예약을 위한 함수 추가
  Future<void> _makeReservation(String roomNumber, DateTime selectedDay,
      String startTime, String endTime) async {
    if (_selectedRoom.isEmpty ||
        _selectedDay == null ||
        _selectedTimes.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false, // 바깥 영역 클릭시 닫히지 않도록 설정
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please select a room, date, and time."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    // 예약 시작 시간과 종료 시간 설정
    final reservationSTime = _selectedTimes.first;
    final reservationETime = _selectedTimes.last;
    final reservationDate =
        "${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')}";
    final roomNumber =
        _selectedRoom.replaceAll(RegExp(r'[^0-9]'), ''); // 호실 번호에서 숫자만 추출

    // API URL 구성
    final url = Uri.parse('$apiURL/api/meeting-room/reservation');

    try {
      final token = await storage.read(key: 'auth_token');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'meeting_room_number': roomNumber,
          'reservation_date': reservationDate,
          'reservation_s_time': reservationSTime,
          'reservation_e_time': reservationETime,
        }),
      );

      // 서버 응답 상태 코드 및 본문 출력
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // 종료 시간에서 시간 부분만 추출
      int endIndex = reservationETime.indexOf(":"); // ":" 문자의 위치를 찾음
      String reservationEHour = reservationETime.substring(
          0, endIndex); // 시작부터 ":" 문자 위치까지의 부분 문자열을 추출

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // 수정된 AlertDialog 호출
        showDialog(
          context: context,
          barrierDismissible: false, // 바깥 영역 클릭시 닫히지 않도록 설정
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("회의실 예약 완료"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("날짜: $reservationDate"),
                    Text("호실: $roomNumber"),
                    // 예약 종료 시간에서 시간 부분만 표시
                    Text(
                        "시간: $reservationSTime ~ ${reservationETime.split(":")[0]}:59"),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text("확인"),
                  onPressed: () {
                    Navigator.of(context).popUntil(
                        (route) => route.isFirst); // 첫 번째 페이지까지 모든 페이지를 닫음
                    Navigator.pushNamed(context, '/meeting_room_main');
                  },
                ),
              ],
            );
          },
        );
      } else {
        // 실패 메시지 표시 (상태 코드를 포함하여)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(
                  "Failed to make a reservation. Status Code: ${response.statusCode}"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: "회의실 예약"),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      drawer: BaseDrawer(),
      body: CustomSingleChildScrollView(
        child: Column(
          children: [
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '예약 날짜 선택',
                style: TextStyle(fontSize: 20),
              ),
            ),
            TableCalendar(
              locale: 'ko_KR',
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(Duration(days: 30)),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedRoom = ''; // 회의실 선택 초기화
                  _selectedTimes.clear(); // 선택된 시간 초기화
                  _maxSelectableTime = null; // 최대 선택 가능 시간 초기화
                });
              },
              headerStyle: HeaderStyle(formatButtonVisible: false),
            ),
            if (_selectedDay != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('회의실 선택', style: TextStyle(fontSize: 20)),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _meetingRooms.map((roomNumber) {
                    // 여기에서 roomNumber 뒤에 "호"를 추가합니다.
                    String roomNumberWithSuffix = roomNumber + '호';
                    return MeetingRoomCard(
                      roomNumber: roomNumberWithSuffix, // "호"를 추가한 문자열을 사용합니다.
                      roomAvailable: true,
                      onTap: () {
                        setState(() {
                          _selectedRoom =
                              roomNumber; // 상태 업데이트에는 "호"가 없는 원래 번호를 사용합니다.
                          fetchReservedTimes(roomNumber, _selectedDay!);
                        });
                      },
                      isSelected: _selectedRoom == roomNumber,
                    );
                  }).toList(),
                ),
              ),
            ],
            if (_selectedRoom.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('예약 시간 선택', style: TextStyle(fontSize: 20)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(19, (index) {
                    final time = '${index + 5 < 10 ? '0' : ''}${index + 5}:00';
                    final isReserved = _reservedTimes.contains(time);
                    final isSelected = _selectedTimes.contains(time);
                    final isBeforeMinTime = _minSelectableTime != null &&
                        time.compareTo(_minSelectableTime!) < 0;
                    final isAfterMaxTime = _maxSelectableTime != null &&
                        time.compareTo(_maxSelectableTime!) >= 0;

                    return ChoiceChip(
                      label: Text(time,
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black)),
                      selected: isSelected,
                      onSelected:
                          isReserved || isBeforeMinTime || isAfterMaxTime
                              ? null
                              : (_) {
                                  setState(() {
                                    _updateSelectableTimes(time);
                                  });
                                },
                      backgroundColor:
                          isReserved || isBeforeMinTime || isAfterMaxTime
                              ? Colors.grey
                              : Colors.grey[200],
                      selectedColor: Theme.of(context).primaryColor,
                      showCheckmark: false,
                    );
                  }),
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  // 여기서 '예약 하기' 버튼이 클릭되었을 때의 동작을 정의합니다.
                  if (_selectedRoom.isNotEmpty &&
                      _selectedDay != null &&
                      _selectedTimes.isNotEmpty) {
                    final startDate = _selectedTimes.first;
                    final endDate = _selectedTimes.last;
                    await _makeReservation(
                        _selectedRoom, _selectedDay!, startDate, endDate);
                  } else {
                    // 필요한 정보가 모두 선택되지 않았을 때 사용자에게 알림
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("예약 실패"),
                          content: Text("모든 정보를 올바르게 입력해주세요."),
                          actions: <Widget>[
                            TextButton(
                              child: Text("닫기"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('예약 하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MeetingRoomCard extends StatelessWidget {
  final String roomNumber;
  final bool roomAvailable;
  final VoidCallback onTap;
  final bool isSelected;

  const MeetingRoomCard({
    Key? key,
    required this.roomNumber,
    required this.roomAvailable,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: roomAvailable ? onTap : null,
      child: Container(
        width: 120,
        height: 80,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: roomAvailable
              ? Color.fromARGB(255, 234, 234, 234)
              : Color.fromARGB(255, 189, 189, 189),
          border: isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              roomNumber,
              style: TextStyle(
                color: roomAvailable
                    ? Color.fromARGB(255, 29, 127, 159)
                    : Color.fromARGB(255, 118, 139, 146),
                fontSize: 15,
              ),
            ),
            Text(
              roomAvailable ? '예약가능' : '예약불가',
              style: TextStyle(
                color: roomAvailable
                    ? Colors.black
                    : Color.fromARGB(255, 255, 0, 0),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
