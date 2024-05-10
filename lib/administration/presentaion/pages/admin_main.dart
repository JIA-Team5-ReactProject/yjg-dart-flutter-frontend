import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yjg/administration/data/data_sources/meeting_room_data_source.dart';
import 'package:yjg/administration/data/data_sources/std_as_data_source.dart';
import 'package:yjg/shared/widgets/custom_singlechildscrollview.dart';
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/white_main_rounded_box.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/base_drawer.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:yjg/shared/widgets/move_button.dart';

class AdminMain extends StatefulWidget {
  const AdminMain({super.key});

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  final _stdAsDataSource = StdAsDataSource();
  final _meetingRoomDataSource = MeetingRoomDataSource();

  Map<String, dynamic>? latestReservation;
  Map<String, dynamic>? latestASRequest;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  void fetchInitialData() async {
    latestReservation = await fetchLatestReservation();
    latestASRequest = await fetchLatestASRequest();
    setState(() {});
  }

  Future<Map<String, dynamic>?> fetchLatestReservation() async {
    try {
      final response = await _meetingRoomDataSource.fetchLatestReservation();
      final data = response.data;
      List<dynamic> reservations = data['meeting_room_reservations'];
      if (reservations.isNotEmpty) {
        return reservations.first;
      }
      return null;
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchLatestASRequest() async {
    try {
      final response = await _stdAsDataSource.fetchLatestASRequest();
      final data = response.data;
      List<dynamic> reservations = data['after_services'];
      if (reservations.isNotEmpty) {
        reservations.sort((a, b) => a['visit_date'].compareTo(b['visit_date']));
        return reservations.first;
      }
      return null;
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(),
      appBar: const BaseAppBar(title: '행정'),
      drawer: BaseDrawer(),
      body: CustomSingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //겹쳐진 박스
            SizedBox(
              height: 150.0,
              child: Stack(
                children: [
                  BlueMainRoundedBox(),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.04),
                    child: FutureBuilder<Map<String, dynamic>?>(
                      future: fetchLatestReservation(),
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // 로딩 중
                        } else if (snapshot.hasData && snapshot.data != null) {
                          final reservation = snapshot.data!;
                          final meetingRoomNumber =
                              reservation['meeting_room_number'];
                          final startTime =
                              reservation['reservation_s_time'].substring(0, 5);
                          final endTime =
                              "${reservation['reservation_e_time'].substring(0, 2)}:59";

                          return WhiteMainRoundedBox(
                            iconData: Icons.headset_mic,
                            mainText: '생활관B동 - $meetingRoomNumber호',
                            secondaryText:
                                '예약 날짜: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(reservation['reservation_date']))}',
                            actionText: '예약 시간: $startTime ~ $endTime',
                            timeText: '',
                          );
                        } else {
                          return Container(
                            height: 120.0,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Palette.stateColor4.withOpacity(0.5),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      Palette.mainColor.withOpacity(0.1),
                                  radius: 30.0,
                                  child: Icon(
                                    Icons.headset_mic,
                                    color: Palette.mainColor.withOpacity(0.7),
                                    size: 30.0,
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '예약 된 회의실 없음',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Palette.textColor,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                      SizedBox(height: 3.0), // 텍스트 간격 조정
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            //식수 이용하기 글자
            Container(
              margin: EdgeInsets.all(20),
              alignment: Alignment(-0.85, 0.2),
              child: const Text(
                '행정 이용하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            //이동 버튼 배치
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: const Wrap(
                spacing: 30, // 아이템들 사이의 가로 간격
                runSpacing: 30, // 아이템들 사이의 세로 간격
                children: <Widget>[
                  MoveButton(
                      icon: Icons.campaign_outlined,
                      text1: '공지사항',
                      text2: '글로벌 캠퍼스 공지',
                      route: '/notice'),
                  MoveButton(
                      icon: Icons.construction,
                      text1: 'AS 요청',
                      text2: '글로벌 캠퍼스 AS',
                      route: '/as_page'),
                  MoveButton(
                      icon: Icons.hotel,
                      text1: '외박/외출 신청',
                      text2: '생활관 외박/외출',
                      route: '/sleepover'),
                  MoveButton(
                      icon: Icons.groups,
                      text1: '회의실 예약',
                      text2: '생활관B동 회의실',
                      route: '/meeting_room_main'),
                ],
              ),
            ),
            //AS현재 진행도
            FutureBuilder<Map<String, dynamic>?>(
              future: Future.value(latestASRequest),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                return Container(
                  height: 80,
                  width: 330,
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Palette.stateColor4.withOpacity(0.5),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundColor: Palette.mainColor.withOpacity(0.1),
                        radius: 30.0,
                        child: Icon(
                          Icons.construction,
                          color: Palette.mainColor.withOpacity(0.7),
                          size: 30.0,
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.hasData && snapshot.data != null
                                  ? 'AS 방문 예정'
                                  : 'AS 예약 없음',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Palette.textColor,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: 3.0), // 텍스트 간격 조절
                            if (snapshot.hasData && snapshot.data != null)
                              Text(
                                snapshot.data!['title'], // API에서 가져온 'title'
                                style: TextStyle(
                                  color: Palette.stateColor4,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (snapshot.hasData && snapshot.data != null)
                        Text(
                          DateFormat('yyyy-MM-dd').format(DateTime.parse(
                              snapshot.data!['visit_date'])), // 'visit_date' 포맷
                          style: TextStyle(
                            color: Palette.mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
