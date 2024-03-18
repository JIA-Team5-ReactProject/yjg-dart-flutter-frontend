import 'package:flutter/material.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  static final storage = FlutterSecureStorage(); //정원이가 말해준 코드(토큰)

  //외박/외출 필드 전부 안 채웠을 때 함수
  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }

  //외박/외출 필드 입력 완료 후 함수
  void _showSuccessDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 성공 메시지 대화상자 닫기
                Navigator.of(context).pop(); // 외박/외출 신청 페이지 닫기
                Navigator.of(context)
                    .pushReplacementNamed('/sleepover'); // '/sleepover' 경로로 이동
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
      drawer: const BaseDrawer(),
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
            }),
            SizedBox(height: 8),
            _datePickerButton('외출/외박 종료 날짜를 선택하세요', _endDate, (DateTime date) {
              setState(() => _endDate = date);
            }),
            SizedBox(height: 30),
            Text('사유',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
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
  Widget _datePickerButton(
      String hint, DateTime? selectedDate, ValueChanged<DateTime> onSelected) {
    return OutlinedButton(
      onPressed: () async {
        DateTime firstDate = DateTime.now(); // 선택 가능한 첫 번째 날짜, 기본값은 오늘
        DateTime lastDate = DateTime.now()
            .add(Duration(days: 30)); // 선택 가능한 마지막 날짜, 기본값은 오늘부터 30일 후

        if (hint.contains('시작')) {
          // 시작 날짜 선택기
          if (_endDate != null) {
            // 종료 날짜가 이미 선택되어 있다면, 선택 가능한 마지막 날짜를 종료 날짜로 설정
            lastDate = _endDate!;
          }
        } else {
          // 종료 날짜 선택기
          // 종료 날짜 선택기의 경우 firstDate와 lastDate의 기본값 사용
        }

        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: firstDate,
          lastDate: lastDate,
          locale: const Locale('ko', 'KR'),
        );
        if (pickedDate != null) {
          onSelected(pickedDate);
        }
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: _primaryColor),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      child: Row(
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
    );
  }

  Widget _reasonInput() {
    return TextField(
      controller: _reasonController,
      maxLines: 10,
      decoration: InputDecoration(
        hintText: '사유를 입력하세요',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: _primaryColor),
        ),
      ),
    );
  }

  Widget _actionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(primary: color),
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
        primary: backgroundColor,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Text(title),
    );
  }

  Future<void> _submitApplication() async {
    final token = await storage.read(key: 'auth_token'); //정원이가 말해준 코드(토큰 불러오기)
    if (_startDate == null ||
        _endDate == null ||
        _reasonController.text.isEmpty) {
      _showDialog('오류', '모든 필드를 입력해주세요.');
      return;
    }

    String type = _startDate == _endDate ? 'go' : 'sleep';
    Uri apiUrl = Uri.parse('$apiURL/api/absence');

    try {
      var response = await http.post(
        apiUrl,
        body: jsonEncode({
          // JSON으로 인코딩
          'start_date': DateFormat('yyyy-MM-dd').format(_startDate!),
          'end_date': DateFormat('yyyy-MM-dd').format(_endDate!),
          'content': _reasonController.text,
          'type': type,
        }),
        headers: {
          //아래 토큰 $token으로 바꿔줘야함
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // JSON 컨텐트 타입
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        String successMessage = '외출/외박 신청이 완료되었습니다.\n\n'
            '시작일: ${DateFormat('yyyy-MM-dd').format(_startDate!)}\n'
            '종료일: ${DateFormat('yyyy-MM-dd').format(_endDate!)}';
        _showSuccessDialog('성공', successMessage);
      } else {
        _showDialog('실패', '외출/외박 신청에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      // 예외 처리
      _showDialog('에러', '오류가 발생했습니다: $e');
    }
  }
}
