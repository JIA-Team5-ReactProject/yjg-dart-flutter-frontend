import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:yjg/shared/constants/api_url.dart';

class SleepoverWidget extends StatefulWidget {
  final int id;
  final int apply; // 0: 거절, 1: 승인
  final String startDate;
  final String lastDate;
  final String content;

  const SleepoverWidget({
    Key? key,
    required this.id,
    required this.apply,
    required this.startDate,
    required this.lastDate,
    required this.content,
  }) : super(key: key);

  @override
  State<SleepoverWidget> createState() => _SleepoverWidgetState();
}

class _SleepoverWidgetState extends State<SleepoverWidget> {
  
  static final storage = FlutterSecureStorage(); //정원이가 말해준 코드(토큰)

  @override
  Widget build(BuildContext context) {
    String statusText;
    Color statusColor;

    switch (widget.apply) {
      case 0:
        statusText = "거절";
        statusColor = Colors.red;
        break;
      default:
        statusText = "승인";
        statusColor = Colors.blue;
    }

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              widget.apply == 0 ? '거절' : '승인',
              style: TextStyle(
                  color: widget.apply == 0 ? Colors.red : Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('시작일: ${widget.startDate}'),
                  Text('종료일: ${widget.lastDate}'),
                  Text('사유: ${widget.content}'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('신청 취소'),
                onPressed: () async {
                  await deleteApplication(widget.id);
                  // 결과를 전달하며 Navigator.pop 메서드 호출
                  Navigator.of(context).pop(); //현재 alert창 닫기
                  Navigator.of(context).pop(); //외박/외출 메인 창 닫기
                  Navigator.pushNamed(context, '/sleepover');
                },
              ),
              TextButton(
                child: Text('닫기'),
                onPressed: () {
                  Navigator.of(context).pop(); // alert 창 닫기

                },
              ),
            ],
          ),
        );
      },
      child: Container(
        width: 380,
        height: 100,
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 5.0,
              blurStyle: BlurStyle.outer,
              color: Color.fromARGB(255, 136, 136, 136),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(width: 25,),
            Container(
              child: Text(
                statusText,
                style: TextStyle(color: statusColor, fontSize: 25),
              ),
            ),
            SizedBox(width: 25,),
            Text(
              widget.startDate,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(' ~ '),
            Container(
              width: 170,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Opacity(
                      opacity: 0.4,
                      child: Image.asset(
                        'assets/img/yju_tiger_logo.png',
                        width: 90,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 37,
                    left: 3,
                    child: Text(
                      widget.lastDate,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //삭제 API 함수
  Future<void> deleteApplication(int id) async {
    final token = await storage.read(key: 'auth_token'); //정원이가 말해준 코드(토큰 불러오기)
    final Uri apiUri = Uri.parse(
        '$apiURL/api/absence/$id');

    final response = await http.delete(apiUri, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      // 성공적으로 삭제됐을 때의 처리 로직 (예: 리스트 새로고침, 성공 메시지 표시 등)
    } else {
      // 실패했을 때의 처리 로직 (예: 에러 메시지 표시 등)
    }
  }
}
