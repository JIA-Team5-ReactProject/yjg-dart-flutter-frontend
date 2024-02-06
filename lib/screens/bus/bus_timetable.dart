import 'package:flutter/material.dart';
import 'package:yjg/screens/bus/bus_timeline.dart';
import 'package:yjg/theme/palette.dart';

class BusTimetable extends StatefulWidget {
  final String selectedRoute;

  const BusTimetable({Key? key, required this.selectedRoute}) : super(key: key);

  @override
  _BusTimetableState createState() => _BusTimetableState();
}

class _BusTimetableState extends State<BusTimetable> {
  int? selectedRound;

  List<Map<String, dynamic>> getScheduleData(String route) {
    switch (route) {
      case '평일-영어출':
        return [
          {'round': 1, 'start': '10:00', 'arrival': '10:45'},
          {'round': 2, 'start': '14:30', 'arrival': '15:15'},
          {'round': 3, 'start': '17:05', 'arrival': '18:15'},
          {'round': 4, 'start': '20:00', 'arrival': '20:40'},
          {'round': 5, 'start': '21:25', 'arrival': '22:00'},
        ];
      case '평일-복현출':
        return [
          {'round': 1, 'start': '7:29', 'arrival': '8:50'},
          {'round': 2, 'start': '13:00', 'arrival': '13:40'},
          {'round': 3, 'start': '15:50', 'arrival': '16:30'},
          {'round': 4, 'start': '19:10', 'arrival': '19:55'},
          {'round': 5, 'start': '20:45', 'arrival': '21:25'},
        ];

      case '주말-영어출':
        return [
          {'round': 1, 'start': '8:20', 'arrival': '8:55'},
          {'round': 2, 'start': '10:40', 'arrival': '11:50'},
          {'round': 3, 'start': '16:00', 'arrival': '17:05'},
          {'round': 4, 'start': '20:10', 'arrival': '21:15'},
        ];

      case '주말-복현출':
        return [
          {'round': 1, 'start': '10:00', 'arrival': '10:40'},
          {'round': 2, 'start': '14:00', 'arrival': '15:10'},
          {'round': 3, 'start': '18:10', 'arrival': '18:55'},
          {'round': 4, 'start': '21:15', 'arrival': '22:00'},
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> scheduleData =
        getScheduleData(widget.selectedRoute);

    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder( // ListView.builder: 스크롤 가능한 목록을 만들고, 필요한 항목 렌더링 시 효율적으로 항목 생성 및 재사용
            physics: NeverScrollableScrollPhysics(), // 사용자가 목록을 스크롤할 수 없게 만듦(physics: 물리적 동작 조정)
            shrinkWrap: true,  // ListView의 크기를 자식의 크기에 맞게 조정
            itemCount: scheduleData.length, // 목록의 항목 개수 
            itemBuilder: (BuildContext context, int index) { // 목록의 각 항목을 만들기 위한 함수
              final data = scheduleData[index];
              bool isSelected = selectedRound == data['round'];

              return Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.only(left: 16.0, right: 0.0),
                      title: Text('회차: ${data['round']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      subtitle: Text('출발: ${data['start']} - 도착: ${data['arrival']}'),
                      trailing: TextButton(
                        onPressed: () => setState(() {
                          if (isSelected) {
                            selectedRound = null; 
                          } else {
                            selectedRound = data['round']; 
                          }
                        }),
                        child: Text(
                          isSelected ? '접기' : '상세', // isSelected 상태에 따라 텍스트 변경
                          style: TextStyle(
                              color: Palette.mainColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    if (isSelected)
                      Container(
                        padding: EdgeInsets.all(25.0),
                        child: BusTimeline(),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
