import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yjg/salon/data/data_sources/my_booking_data_source.dart';
import 'package:yjg/shared/theme/palette.dart';
import 'package:yjg/shared/widgets/blue_main_rounded_box.dart';
import 'package:yjg/shared/widgets/notice_box.dart';
import 'package:yjg/shared/widgets/white_main_rounded_box.dart';
import 'package:yjg/shared/widgets/base_appbar.dart';
import 'package:yjg/shared/widgets/bottom_navigation_bar.dart';
import 'package:yjg/shared/widgets/move_button.dart';

class SalonMain extends StatefulWidget {
  SalonMain({Key? key}) : super(key: key);

  @override
  _SalonMainState createState() => _SalonMainState();
}

class _SalonMainState extends State<SalonMain> {
  late Future<String> _isBookFuture;

  @override
  void initState() {
    super.initState();
    _isBookFuture = _fetchIsBook();
  }

  Future<String> _fetchIsBook() async {
    final response = await MyBookingDataSource().getReservationAPI();
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes))['reservations'];
      return jsonResponse.isNotEmpty ? 'true' : 'false';
    } else {
      throw Exception('예약 목록을 불러오지 못했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _isBookFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Center(
              child: CircularProgressIndicator(color: Palette.stateColor4),
          ));
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final isBook = snapshot.data;
          print('예약 정보: $isBook');
          return Scaffold(
            bottomNavigationBar: const CustomBottomNavigationBar(),
            appBar: const BaseAppBar(title: '미용실'),
            drawer: Drawer(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                            iconData: Icons.cut,
                            mainText: isBook == 'true' 
                                ? '미용실 예약이 있습니다.'
                                : '미용실 예약이 없습니다.',
                            secondaryText: isBook == 'true'
                                ? '예약 시간을 꼭 지켜주세요.'
                                : "미용실을 이용해 보세요!",
                            actionText: '예약 확인하기',
                            page: 'salon',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  alignment: Alignment(-0.85, 0.2),
                  child: const Text(
                    '미용실 이용하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const Wrap(
                  spacing: 30, // 아이템들 사이의 가로 간격
                  runSpacing: 30, // 아이템들 사이의 세로 간격
                  children: <Widget>[
                    MoveButton(
                        icon: Icons.add_task,
                        text1: '예약',
                        text2: '미용실 예약',
                        route: '/salon_booking_step_one'),
                    MoveButton(
                        icon: Icons.content_paste_search,
                        text1: '가격표',
                        text2: '미용실 이용 가격 안내',
                        route: '/salon_price_list'),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.all(20),
                  alignment: Alignment(-0.85, 0.2),
                  child: const Text(
                    '미용실 공지사항',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 140.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0), // 오른쪽에 20픽셀 간격을 줍니다.
                        child: NoticeBox(
                          title: '미용실 휴무 안내',
                          content:
                              '미용실 휴무합니다. 2025년 1월 1일부터 2025년 1월 3일까지 휴무이므로, 이용....',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0), // 오른쪽에 20픽셀 간격을 줍니다.
                        child: NoticeBox(
                          title: '미용실 휴무 안내',
                          content:
                              '미용실 휴무합니다. 2025년 1월 1일부터 2025년 1월 3일까지 휴무이므로, 이용....',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0), // 오른쪽에 20픽셀 간격을 줍니다.
                        child: NoticeBox(
                          title: '미용실 휴무 안내',
                          content:
                              '미용실 휴무합니다. 2025년 1월 1일부터 2025년 1월 3일까지 휴무이므로, 이용....',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
