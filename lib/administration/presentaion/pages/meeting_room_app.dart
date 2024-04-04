import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yjg/administration/data/data_sources/meeting_room_data_source.dart';
import 'package:yjg/shared/theme/palette.dart';
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
  List<Map<String, dynamic>> _meetingRooms = []; //받아온 회의실 목록을 저장해주는 API
  final _meetingRoomDataSource = MeetingRoomDataSource();

  String? _minSelectableTime; // 사용자가 선택할 수 있는 최소 시간을 저장하는 변수
  String? _maxSelectableTime; // 사용자가 선택할 수 있는 최대 시간을 저장하는 변수

  // * 해당 회의실 마다의 예약 된 시간 목록을 받아오는 API
  Future<void> fetchReservedTimes(String roomNumber, DateTime date) async {
    try {
      final response =
          await _meetingRoomDataSource.fetchReservedTimes(roomNumber, date);

      final data = response.data;
      setState(() {
        _reservedTimes = List<String>.from(data['reservations']);
        _maxSelectableTime = null; // 새로운 호실을 선택할 때는 최대 선택 가능 시간을 리셋합니다.
      });
    } catch (e) {
      setState(() {
        _reservedTimes = [];
        _maxSelectableTime = null;
      });
    }
  }

  // * 회의실의 목록을 받아오는 API
  Future<void> fetchMeetingRooms() async {
    try {
      final response = await _meetingRoomDataSource.fetchMeetingRooms();
      final data = response.data;
      final rooms = List<Map<String, dynamic>>.from(
        data['meeting_rooms'].map((room) => {
              'room_number': room['room_number'],
              'open': room['open'], // "open" 값을 추가로 저장합니다.
            }),
      );

      setState(() {
        _meetingRooms = rooms;
      });
    } catch (e) {
      // 에러 처리
      debugPrint('회의실 목록 로드 실패: $e');
    }
  }

  void _updateSelectableTimes(String selectedTime) {
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

    // `_reservedTimes` 리스트를 순회하며 `lastTime` 이후의 가장 빠른 예약된 시간을 찾음.
    // 예약된 시간이 없다면, 최대 선택 가능 시간을 하루의 마지막 시간으로 설정.
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

  // * 예약을 위한 함수 추가
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

    try {
      await _meetingRoomDataSource.makeReservation(
          roomNumber, reservationDate, reservationSTime, reservationETime);

      // 종료 시간에서 시간 부분만 추출
      int endIndex = reservationETime.indexOf(":"); // ":" 문자의 위치를 찾음
      String reservationEHour = reservationETime.substring(
          0, endIndex); // 시작부터 ":" 문자 위치까지의 부분 문자열을 추출
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('회의실 예약이 완료되었습니다.'),
          backgroundColor: Palette.mainColor,
        ),
      );
      Navigator.of(context)
          .popUntil((route) => route.isFirst); // 첫 번째 페이지까지 모든 페이지를 닫음
      Navigator.pushNamed(context, '/admin_main');
      Navigator.pushNamed(context, '/meeting_room_main');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('회의실 예약에 실패했습니다.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth =
        MediaQuery.of(context).size.width; // MediaQuery를 사용하여 현재 화면 크기를 가져옴.

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
            Container(
              width: screenWidth * 0.9, // 너비 조정
              height: 350, // 높이 조정
              child: TableCalendar(
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
            ),
            if (_selectedDay != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('회의실 선택', style: TextStyle(fontSize: 20)),
              ),
              Container(
                width: screenWidth * 0.9, // 너비 조정
                height: 100,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _meetingRooms.map((room) {
                        // "room" 맵에서 "room_number"와 "open" 값을 추출
                        String roomNumberWithSuffix = room['room_number'] + '호';
                        bool roomAvailable =
                            room['open'] == 1; // "open" 값에 따라 bool 값을 설정

                        return MeetingRoomCard(
                          roomNumber: roomNumberWithSuffix,
                          roomAvailable: roomAvailable,
                          onTap: () {
                            setState(() {
                              _selectedRoom = room['room_number'];
                              fetchReservedTimes(
                                  room['room_number'], _selectedDay!);
                            });
                          },
                          isSelected: _selectedRoom == room['room_number'],
                        );
                      }).toList(),
                    )),
              ),
            ],
            if (_selectedRoom.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('예약 시간 선택', style: TextStyle(fontSize: 20)),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(19, (index) {
                      final time =
                          '${index + 5 < 10 ? '0' : ''}${index + 5}:00';
                      final isReserved = _reservedTimes.contains(time);
                      final isSelected = _selectedTimes.contains(time);
                      final isBeforeMinTime = _minSelectableTime != null &&
                          time.compareTo(_minSelectableTime!) < 0;
                      final isAfterMaxTime = _maxSelectableTime != null &&
                          time.compareTo(_maxSelectableTime!) >= 0;

                      return ChoiceChip(
                        label: Text(time,
                            style: TextStyle(
                                color:
                                    isSelected ? Colors.white : Colors.black)),
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
              ),
            ],
            if (_selectedTimes.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // 여기서 '예약 하기' 버튼이 클릭되었을 때의 동작을 정의
                    if (_selectedRoom.isNotEmpty &&
                        _selectedDay != null &&
                        _selectedTimes.isNotEmpty) {
                      final startDate = _selectedTimes.first;
                      final endDate = _selectedTimes.last;
                      await _makeReservation(
                          _selectedRoom, _selectedDay!, startDate, endDate);
                    } else {
                      // 필요한 정보가 모두 선택되지 않았을 때 사용자에게 알림을 띄움
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.mainColor, // 배경색 변경
                    foregroundColor: Colors.white, // 글자색 변경
                  ),
                ),
              ),
            ],
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
