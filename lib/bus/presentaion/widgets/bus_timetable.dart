import 'package:flutter/material.dart';
import 'package:yjg/bus/presentaion/widgets/bus_timeline_show_modal.dart';
import 'package:yjg/shared/theme/palette.dart';

class BusTimetable extends StatefulWidget {
  final String selectedRoute;

  const BusTimetable({
    Key? key,
    required this.selectedRoute,
  }) : super(key: key);

  @override
  _BusTimetableState createState() => _BusTimetableState();
}

class _BusTimetableState extends State<BusTimetable> {
  List<Map<String, dynamic>> getScheduleData() {
    List<Map<String, dynamic>> allSchedules = []; // 전체 스케줄을 담을 리스트

    // 평일과 주말 데이터를 별도로 분류
    List<Map<String, dynamic>> weekdaySchedules = [
      ...getSpecificScheduleData('평일-영어출'),
      ...getSpecificScheduleData('평일-복현출'),
    ];
    List<Map<String, dynamic>> weekendSchedules = [
      ...getSpecificScheduleData('주말-영어출'),
      ...getSpecificScheduleData('주말-복현출'),
    ];

    switch (widget.selectedRoute) {
      case '전체':
        allSchedules.add({'isTitle': true, 'title': '평일-영어출'});
        allSchedules.addAll(getSpecificScheduleData('평일-영어출'));
        allSchedules.add({'isTitle': true, 'title': '평일-복현출'});
        allSchedules.addAll(getSpecificScheduleData('평일-복현출'));
        allSchedules.add({'isTitle': true, 'title': '주말-영어출'});
        allSchedules.addAll(getSpecificScheduleData('주말-영어출'));
        allSchedules.add({'isTitle': true, 'title': '주말-복현출'});
        allSchedules.addAll(getSpecificScheduleData('주말-복현출'));
        break;
      case '평일':
        allSchedules.add({'isTitle': true, 'title': '평일-영어출'});
        allSchedules.addAll(getSpecificScheduleData('평일-영어출'));
        allSchedules.add({'isTitle': true, 'title': '평일-복현출'});
        allSchedules.addAll(getSpecificScheduleData('평일-복현출'));
        break;
      case '주말':
        allSchedules.add({'isTitle': true, 'title': '주말-영어출'});
        allSchedules.addAll(getSpecificScheduleData('주말-영어출'));
        allSchedules.add({'isTitle': true, 'title': '주말-복현출'});
        allSchedules.addAll(getSpecificScheduleData('주말-복현출'));
        break;
      default:
        // 선택된 루트가 특정 경우에 해당하지 않을 때
        allSchedules = [];
    }

    return allSchedules;
  }

  List<Map<String, dynamic>> getSpecificScheduleData(String route) {
    List<Map<String, dynamic>> data = [];
    switch (route) {
      case '평일-영어출':
        return [
          {'route': '평일(영어)', 'round': 1, 'start': '10:00', 'arrival': '10:45'},
          {'route': '평일(영어)', 'round': 2, 'start': '14:30', 'arrival': '15:15'},
          {'route': '평일(영어)', 'round': 3, 'start': '17:05', 'arrival': '18:15'},
          {'route': '평일(영어)', 'round': 4, 'start': '20:00', 'arrival': '20:40'},
          {'route': '평일(영어)', 'round': 5, 'start': '21:25', 'arrival': '22:00'},
        ];
      case '평일-복현출':
        return [
          {'route': '평일(복현)', 'round': 1, 'start': '7:29', 'arrival': '8:50'},
          {'route': '평일(복현)', 'round': 2, 'start': '13:00', 'arrival': '13:40'},
          {'route': '평일(복현)', 'round': 3, 'start': '15:50', 'arrival': '16:30'},
          {'route': '평일(복현)', 'round': 4, 'start': '19:10', 'arrival': '19:55'},
          {'route': '평일(복현)', 'round': 5, 'start': '20:45', 'arrival': '21:25'},
        ];

      case '주말-영어출':
        return [
          {'route': '주말(영어)', 'round': 1, 'start': '8:20', 'arrival': '8:55'},
          {'route': '주말(영어)', 'round': 2, 'start': '10:40', 'arrival': '11:50'},
          {'route': '주말(영어)', 'round': 3, 'start': '16:00', 'arrival': '17:05'},
          {'route': '주말(영어)', 'round': 4, 'start': '20:10', 'arrival': '21:15'},
        ];

      case '주말-복현출':
        return [
          {'route': '주말(복현)', 'round': 1, 'start': '10:00', 'arrival': '10:40'},
          {'route': '주말(복현)', 'round': 2, 'start': '14:00', 'arrival': '15:10'},
          {'route': '주말(복현)', 'round': 3, 'start': '18:10', 'arrival': '18:55'},
          {'route': '주말(복현)', 'round': 4, 'start': '21:15', 'arrival': '22:00'},
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> scheduleData = getScheduleData();

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20.0),
          // ListView.builder를 사용하여 스케줄 데이터를 반복적으로 표시
          ListView.builder(
            shrinkWrap: true, // SingleChildScrollView 내부에서 ListView를 사용할 때 필요
            physics:
                NeverScrollableScrollPhysics(), // SingleChildScrollView와의 스크롤 충돌을 방지
            itemCount: scheduleData.length, // 스케줄 데이터의 길이만큼 아이템을 생성
            itemBuilder: (context, index) {
              // 현재 스케줄 데이터
              Map<String, dynamic> item = scheduleData[index];

              if (item.containsKey('isTitle') && item['isTitle']) {
                // 섹션 제목인 경우
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      item['title'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Palette.mainColor),
                    ),
                  ),
                );
              }
              return InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // BottomSheet의 최대 높이를 조절하기 위해 필요함
                    builder: (BuildContext context) {
                      return FractionallySizedBox(
                        heightFactor: 0.5,
                        child: Container(
                          padding: EdgeInsets.all(20), // 내부 여백 추가
                          child: Column(
                            children: [
                              Text(
                                "상세 노선",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Palette.mainColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "도로 사정에 따라 ±10분의 차이가 있을 수 있습니다.",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Palette.textColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 25), // 텍스트와 타임라인 사이의 간격 추가
                              Expanded(
                                child:
                                    BusTimelineShowModal(), // BusTimeline 위젯을 사용하여 타임라인 표시
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30.0),
                    height: 110.0,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: Palette.stateColor4.withOpacity(0.3),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${item['route']} ${item['round']}회차',
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      color: Palette.stateColor4,
                                      fontWeight: FontWeight.w100),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '${item['start']}',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Palette.mainColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '...................................',
                                style: TextStyle(color: Palette.stateColor4),
                              ),
                              Text(
                                '${item['arrival']}',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Palette.mainColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '영어마을',
                                style: TextStyle(),
                              ),
                              Text(
                                '복현서문',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
