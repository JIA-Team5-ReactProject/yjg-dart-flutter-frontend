import 'package:flutter/material.dart';
import 'package:yjg/administration/data/data_sources/meeting_room_data_source.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';

import 'package:intl/intl.dart';

import 'package:yjg/shared/widgets/meeting_room_card.dart';

class MeetingRoomMain extends StatefulWidget {
  const MeetingRoomMain({super.key});

  @override
  State<MeetingRoomMain> createState() => _MeetingRoomMainState();
}

class _MeetingRoomMainState extends State<MeetingRoomMain> {
  final _meetingRoomDataSource = MeetingRoomDataSource();

  // * API 통신 함수 (회의실 카드에 쓸 데이터 불러오기)
  Future<List<dynamic>> fetchASRequests() async {
    try {
      final response = await _meetingRoomDataSource.fetchASRequests();
      final data = response.data;
      List<dynamic> reservations = data['meeting_room_reservations'];

      // 현재 날짜 (시간 정보 무시)
      final today = DateTime.now();
      final currentDate = DateTime(today.year, today.month, today.day);

      // 'reservation_date'만 사용하여 날짜 비교
      reservations = reservations.where((reservation) {
        final reservationDate = DateTime.parse(reservation['reservation_date']);
        return reservationDate.isAfter(currentDate) ||
            reservationDate.isAtSameMomentAs(currentDate);
      }).toList();

      return reservations;
    } catch (e) {
      throw Exception('Failed to fetch reservations. Error: $e');
    }
  }

  // * 예약 삭제 API 통신 함수
  Future<void> deleteReservation(
      BuildContext context, int reservationId) async {
    try {
      await _meetingRoomDataSource.deleteReservation(reservationId);
      // 성공적으로 삭제되었을 때의 처리
      Navigator.of(context).pop(); // 삭제 확인 대화상자 닫기
      Navigator.of(context).pop(); // 예약 정보 대화상자 닫기
      Navigator.of(context).pop(); // 회의실 예약 메인페이지 닫기
      Navigator.pushNamed(context, '/meeting_room_main'); //회의실 예약 메인 다시 열기
    } catch (e) {
      throw Exception('예약 삭제에 실패했습니다.: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: '회의실 예약'),
      drawer: BaseDrawer(),
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
                    return Center(
                        child: Text(
                      "현재 예약된 회의실이 없습니다.",
                      style: TextStyle(color: Colors.grey),
                    ));
                    return Center(
                        child: Text(
                      "현재 예약된 회의실이 없습니다.",
                      style: TextStyle(color: Colors.grey),
                    ));
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
    final startTime = DateFormat.Hm().format(
        DateTime.parse("2000-01-01 ${reservation['reservation_s_time']}"));
    Color textColor; // 텍스트 색상을 저장할 변수
    String statusText; // 텍스트 내용을 저장할 변수

    // status 값에 따라 텍스트 색상과 내용 설정
    if (reservation['status'] == 1) {
      textColor = Colors.blue; // 파란색 설정
      statusText = '예약 승인'; // 승인된 예약
    } else {
      textColor = Colors.red; // 빨간색 설정
      statusText = '예약 거절'; // 거절된 예약
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(statusText,
              style: TextStyle(color: textColor)), // 여기서 색상과 내용을 적용
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(" B동 ${reservation['meeting_room_number']}호",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              Container(
                width: 350,
                padding: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color.fromARGB(255, 162, 162, 162),
                      width: 1, // 여기에서 테두리의 두께를 설정
                    ),
                  ),
                ),
                child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      " ${reservation['reservation_date']}",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(width: 20,),
                    Text(
                        "$startTime ~ ${reservation['reservation_e_time'].split(':')[0]}:59",style: TextStyle(fontSize: 15),),
                  ],
                ),
              ),
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
