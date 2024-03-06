import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
                  Navigator.of(context).pop(true); // true는 성공적으로 삭제됐음을 나타냄
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
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                statusText,
                style: TextStyle(color: statusColor, fontSize: 25),
              ),
            ),
            Text(
              widget.startDate,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text('~'),
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
                        width: 80,
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
    final String token = "34|cDBOA63alAk3QBqSnCEpPYG5Unvp7hcNUUFFRr7a77a553e8";
    final Uri apiUri = Uri.parse(
        'http://ec2-13-124-102-253.ap-northeast-2.compute.amazonaws.com/api/absence/$id');

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
