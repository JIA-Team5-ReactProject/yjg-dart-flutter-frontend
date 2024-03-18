import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:yjg/shared/widgets/meeting_room_card.dart';

class MeetingRoomMain extends StatefulWidget {
  const MeetingRoomMain({super.key});

  @override
  State<MeetingRoomMain> createState() => _MeetingRoomMainState();
}

class _MeetingRoomMainState extends State<MeetingRoomMain> {
  static final storage = FlutterSecureStorage(); //정원이가 말해준 코드(토큰)

  // API 통신 함수 (AS카드에 쓸 데이터 불러오기)
  Future<List<dynamic>> fetchASRequests() async {
    try {
      final token = await storage.read(key: 'auth_token');
      final response = await http.get(
        Uri.parse('$apiURL/api/meeting-room/reservation/user'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> reservations = data['meeting_room_reservations'];

        // 현재 날짜 (시간 정보 무시)
        final today = DateTime.now();
        final currentDate = DateTime(today.year, today.month, today.day);

        // 'reservation_date'만 사용하여 날짜 비교
        reservations = reservations.where((reservation) {
          final reservationDate =
              DateTime.parse(reservation['reservation_date']);
          return reservationDate.isAfter(currentDate) ||
              reservationDate.isAtSameMomentAs(currentDate);
        }).toList();

        return reservations;
      } else {
        throw Exception(
            'Failed to fetch reservations. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch reservations. Error: $e');
    }
  }

  //예약 삭제 API 통신 함수
  Future<void> deleteReservation(
      BuildContext context, int reservationId) async {
    final token = await storage.read(key: 'auth_token');
    final response = await http.delete(
      Uri.parse('$apiURL/api/meeting-room/reservation/$reservationId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // 성공적으로 삭제되었을 때의 처리
      Navigator.of(context).pop(); // 삭제 확인 대화상자 닫기
      Navigator.of(context).pop(); // 예약 정보 대화상자 닫기
      Navigator.of(context).pop(); // 회의실 예약 메인페이지 닫기
      Navigator.pushNamed(context, '/meeting_room_main'); //회의실 예약 메인 다시 열기
      
    } else {
      // 삭제 실패 처리
      print(
          'Failed to delete reservation. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: '회의실 예약'),
      drawer: const BaseDrawer(),
      body: Column(
        children: [
          //AS 신청하기 버튼
          SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: [
                BlueMainRoundedBox(),
                //신청하기 버튼
                Container(
                  width: 260,
                  height: 60,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 244, 244, 244)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          // 버튼 모서리를 둥글게 설정
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                    ),
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/meeting_room_app');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.note_add_outlined,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('회의실 예약하기')
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          //신청 내역 글자
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 20, top: 20, bottom: 10),
            child: Text('신청 내역'),
          ),

          //선
          Container(
            width: 380,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Color.fromARGB(255, 0, 0, 0))),
            ),
          ),

          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: fetchASRequests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // 에러 메시지를 보다 상세하게 제공
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else {
                  // 데이터가 있을 때만 ListView를 빌드
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final reservation = snapshot.data![index];
                        return MeetingRoomCard(
                          roomNumber:
                              reservation['meeting_room_number'] ?? 'N/A',
                          reservationDate:
                              reservation['reservation_date'] ?? 'Unknown Date',
                          startTime:
                              reservation['reservation_s_time'] ?? 'Start Time',
                          endTime: reservation['reservation_e_time'] ?? '에',
                          status: reservation['status'] ?? 0,
                          reservationId: reservation['id'],
                          onTap: () => showReservationDialog(
                              context, reservation), // 이 부분이 중요합니다.
                        );
                      },
                    );
                  } else {
                    // 데이터가 없을 경우 사용자에게 알림
                    return Center(child: Text("현재 예약된 회의실이 없습니다."));
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  //예약 정보 확인 alert
  void showReservationDialog(
      BuildContext context, Map<String, dynamic> reservation) {
    final startTime = DateFormat.Hm().format(DateTime.parse(
        "2000-01-01 ${reservation['reservation_s_time']}")); // '2000-01-01'은 임의의 날짜입니다.

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("예약 정보"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("회의실: B동 ${reservation['meeting_room_number']}"),
              Text("예약 날짜: ${reservation['reservation_date']}"),
              Text(
                  "예약 시간: $startTime ~ ${reservation['reservation_e_time'].split(':')[0]}:59"),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("확인"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("삭제"),
              onPressed: () {
                // 삭제 확인 대화상자 표시
                showDeleteConfirmationDialog(context, reservation['id']);
              },
            ),
          ],
        );
      },
    );
  }

  //삭제 확인 alert
  void showDeleteConfirmationDialog(BuildContext context, int reservationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("예약 삭제 확인"),
          content: Text("이 예약을 삭제하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              child: Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("확인"),
              onPressed: () {
                // 예약 삭제 API 호출
                deleteReservation(context, reservationId);
              },
            ),
          ],
        );
      },
    );
  }
}
