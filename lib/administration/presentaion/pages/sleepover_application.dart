import 'package:flutter/material.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

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

  //토큰 수정 필요함 (목록 조회는 이 토큰 값으로만 가능)
  final String _token = "34|cDBOA63alAk3QBqSnCEpPYG5Unvp7hcNUUFFRr7a77a553e8";

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

  Widget _datePickerButton(
      String hint, DateTime? selectedDate, ValueChanged<DateTime> onSelected) {
    return OutlinedButton(
      onPressed: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 5),
          lastDate: DateTime(DateTime.now().year + 5),
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
    if (_startDate == null ||
        _endDate == null ||
        _reasonController.text.isEmpty) {
      _showDialog('오류', '모든 필드를 입력해주세요.');
      return;
    }

    String type = _startDate == _endDate ? 'go' : 'sleep';
    Uri apiUrl = Uri.parse(
        '$apiURL/api/absence');

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
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json', // JSON 컨텐트 타입
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        String successMessage = '외박 신청이 완료되었습니다.\n\n'
            '시작일: ${DateFormat('yyyy-MM-dd').format(_startDate!)}\n'
            '종료일: ${DateFormat('yyyy-MM-dd').format(_endDate!)}';
        _showDialog('성공', successMessage);
      } else {
        _showDialog('실패', '외박 신청에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      // 예외 처리
      _showDialog('에러', '오류가 발생했습니다: $e');
    }
  }
}
