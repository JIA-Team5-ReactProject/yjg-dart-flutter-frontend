import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yjg/administration/data/data_sources/sleepover_data_source.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:intl/intl.dart';

class SleepoverApplication extends StatefulWidget {
  const SleepoverApplication({Key? key}) : super(key: key);

  @override
  State<SleepoverApplication> createState() => _SleepoverApplicationState();
}

class _SleepoverApplicationState extends State<SleepoverApplication> {
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _reasonController = TextEditingController();
  final Color _primaryColor = Color.fromRGBO(0, 127, 160, 1);
  final Color _cancelColor = Colors.red; // 취소 버튼 색상
  final _sleepoverDataSource = SleepoverDataSource();

  //외박/외출 필드 전부 안 채웠을 때 함수
  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title,
              style: TextStyle(
                  color: Palette.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(
                '확인',
                style: TextStyle(color: Palette.stateColor3),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: '외박/외출'),
      drawer: BaseDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.luggage_outlined,
                size: 130,
                color: Color.fromRGBO(0, 127, 160, 1),
              ),
            ),
            SizedBox(height: 30),
            _datePickerButton('외출/외박 시작 날짜를 선택하세요', _startDate,
                (DateTime date) {
              setState(() => _startDate = date);
            }, true), // 시작 날짜를 선택하는 경우이므로 isStartDate는 true입니다.

            SizedBox(height: 8),

            _datePickerButton('외출/외박 종료 날짜를 선택하세요', _endDate, (DateTime date) {
              setState(() => _endDate = date);
            }, false), // 종료 날짜를 선택하는 경우이므로 isStartDate는 false입니다.
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.only(left: 35, bottom: 10),
              child: Text('사유',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
            SizedBox(height: 8),
            _reasonInput(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton('작성완료', _primaryColor, _submitApplication),
                _actionButton('취소', _cancelColor, () => Navigator.pop(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //날짜 선택 함수
  Widget _datePickerButton(String hint, DateTime? selectedDate,
      ValueChanged<DateTime> onSelected, bool isStartDate) {
    double screenWidth = MediaQuery.of(context).size.width; // 화면의 가로 길이를 얻습니다.
    double buttonWidth =
        screenWidth * 0.8; // 예를 들어, 화면 가로 길이의 80%를 버튼의 가로 길이로 설정합니다.

    // Center 위젯을 사용하여 버튼을 가운데 정렬합니다.
    return Center(
      child: Container(
        width: buttonWidth, // 버튼의 가로 길이를 설정합니다.
        child: OutlinedButton(
          onPressed: () =>
              _showCustomCalendarDialog(selectedDate, onSelected, isStartDate),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: _primaryColor),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // 아이콘과 텍스트가 중앙에 위치하도록 합니다.
            children: [
              Icon(Icons.calendar_today, color: _primaryColor),
              SizedBox(width: 10),
              Text(
                selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(selectedDate)
                    : hint,
                style: TextStyle(color: _primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomCalendarDialog(DateTime? selectedDate,
      ValueChanged<DateTime> onSelected, bool isStartDate) {
    DateTime firstDay = DateTime.now();
    DateTime lastDay = DateTime.now().add(Duration(days: 30));
    DateTime focusedDay = selectedDate ?? DateTime.now();

    if (isStartDate && _endDate != null) {
      lastDay = _endDate!;
      if (selectedDate != null && selectedDate.isAfter(lastDay)) {
        focusedDay = _endDate!; // focusedDay가 lastDay 이후가 아닌지 확인
      }
    } else if (!isStartDate && _startDate != null) {
      firstDay = _startDate!;
      if (selectedDate != null && selectedDate.isBefore(firstDay)) {
        focusedDay = _startDate!; // focusedDay가 firstDay 이전이 아닌지 확인
      }
    }

    //focusedDay가 firstDay 이전이나 lastDay 이후가 아닌지 확인
    if (focusedDay.isBefore(firstDay)) {
      focusedDay = firstDay;
    } else if (focusedDay.isAfter(lastDay)) {
      focusedDay = lastDay;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Container(
          width: double.maxFinite,
          height: 350,
          child: TableCalendar(
            locale: 'ko_KR',
            firstDay: firstDay,
            lastDay: lastDay,
            focusedDay: focusedDay,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(selectedDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              onSelected(selectedDay);
              Navigator.of(context).pop(); // 대화상자 닫기
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true, // 제목 가운데 정렬
              formatButtonShowsNext: false,
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false, // 현재 달의 날짜만 표시
              selectedDecoration: BoxDecoration(
                // 선택된 날짜 스타일
                color: Palette.mainColor, // 선택된 날짜의 배경 색상
                shape: BoxShape.circle, // 원형 표시
              ),
              todayDecoration: BoxDecoration(
                // 오늘 날짜 스타일
                color: const Color.fromARGB(255, 128, 128, 128)
                    .withOpacity(0.5), // 오늘 날짜의 배경 색상 (투명도 포함)
                shape: BoxShape.circle, // 원형 표시
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.black, fontSize: 13),
              weekendStyle: TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _reasonInput() {
    double screenWidth = MediaQuery.of(context).size.width; // 화면의 가로 길이를 얻음
    double textFieldWidth =
        screenWidth * 0.8; // 화면 가로 길이의 90%를 입력 필드의 가로 길이로 설정
    return Center(
      child: Container(
        width: textFieldWidth, // 입력 필드의 가로 길이를 설정
        child: TextField(
          controller: _reasonController,
          maxLines: 10,
          decoration: InputDecoration(
            hintText: '사유를 입력하세요',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: _primaryColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildReasonInputSection() {
    return TextField(
      controller: _reasonController,
      maxLines: 10, // 세로 높이 조정
      decoration: InputDecoration(
        hintText: '사유를 입력하세요',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: _primaryColor),
        ),
      ),
    );
  }

  Widget _buildButton(
      String title, Color backgroundColor, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Text(title),
    );
  }

  //외박/외출 신청하는 POST API 함수
  Future<void> _submitApplication() async {
    if (_startDate == null ||
        _endDate == null ||
        _reasonController.text.isEmpty) {
      _showDialog('오류', '모든 필드를 입력해주세요.');
      return;
    }

    String type = _startDate == _endDate ? 'go' : 'sleep';

    try {
      final response = await _sleepoverDataSource.submitApplication(
          _startDate, _endDate, _reasonController, type);

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('외박 신청이 완료되었습니다.'),
            backgroundColor: Palette.mainColor,
          ),
        );
        Navigator.of(context).pop(); // 성공 메시지 대화상자 닫기
        Navigator.of(context).pop(); // 외박/외출 신청 페이지 닫기
        Navigator.of(context)
            .pushReplacementNamed('/sleepover'); // '/sleepover' 경로로 이동
      }
    } on DioException catch (e) {
      // 409 예외 처리
      if (e.response?.statusCode == 409) {
        _showDialog('예약 중복', '이미 신청된 날짜입니다.');
      } else {
        _showDialog('실패', '예기치 못한 오류가 발생했습니다.'); // 예외 메시지를 사용
      }
    } catch (e) {
      // 예외 처리
      _showDialog('에러', '예기치 못한 오류가 발생했습니다.');
    }
  }
}
