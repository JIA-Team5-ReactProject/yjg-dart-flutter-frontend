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
    double screenWidth = MediaQuery.of(context).size.width;

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

    return Container(
      width: screenWidth * 0.85,
      height: 100,
      padding: EdgeInsets.all(20), // 패딩 추가
      margin: EdgeInsets.symmetric(vertical: 10), // 수직 마진 추가
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), // 모서리 둥글게
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3), // 그림자 효과
          ),
        ],
      ),
      child: InkWell(
        child: Container(
            child: Row(
          children: [
            Column(
              children: [
                Icon(
                  Icons.bedtime,
                  color: statusColor,
                  size: 40,
                ),
                Text(
                  statusText,
                  style: TextStyle(color: statusColor, fontSize: 14),
                ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              widget.startDate,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              ' ~ ',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              widget.lastDate,
              style: TextStyle(fontSize: 20),
            ),
          ],
        )),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Container(
                 padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromARGB(255, 162, 162, 162),
                            width: 2, // 여기에서 테두리의 두께를 설정합니다.
                          ),
                        ),
                      ),
                child: Text(
                  widget.apply == 0 ? '거절' : '승인',
                  style: TextStyle(
                      color: widget.apply == 0 ? Colors.red : Colors.blue),
                ),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      margin: EdgeInsets.only(bottom: 10,),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromARGB(255, 162, 162, 162),
                            width: 2, // 여기에서 테두리의 두께를 설정합니다.
                          ),
                        ),
                      ),
                      child: Text(' ${widget.content}',style: TextStyle(fontSize: 20),),
                    ),
                    Text(
                      '   ${widget.startDate} ~ ${widget.lastDate}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
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
      ),
    );
  }

  //삭제 API 함수
  Future<void> deleteApplication(int id) async {
    final token = await storage.read(key: 'auth_token'); //정원이가 말해준 코드(토큰 불러오기)
    final Uri apiUri = Uri.parse('$apiURL/api/absence/$id');

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
