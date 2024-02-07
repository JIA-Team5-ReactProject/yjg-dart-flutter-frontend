import 'package:flutter/material.dart';
import 'package:yjg/theme/palette.dart';

class BusTimeline extends StatelessWidget {
  // TODO: 하드 코딩
  final List<Map<String, String>> stops = [
    {'station': '영어마을', 'time': '10:00'},
    {'station': '글로벌생활관', 'time': '10:03'},
    {'station': '글로벌캠퍼스', 'time': '10:05'},
    {'station': '태전역', 'time': '10:25'},
    {'station': '복현서문', 'time': '10:45'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: stops.length,
      itemBuilder: (context, index) {
        final stop = stops[index];
        final bool isLastStop = index == stops.length - 1;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    stop['time'] ?? '',
                    style: TextStyle(fontSize: 13, color: Palette.mainColor, fontWeight: FontWeight.bold),
                  ),
                  if (!isLastStop) ...[
                    // 조건문을 이용하여 마지막 정류장이 아닐 때만 점과 선을 표시
                    // Container(
                    //   height: 10,
                    //   width: 10,
                    //   margin: EdgeInsets.only(top: 4, bottom: 4),
                    //   decoration: BoxDecoration(
                    //     color: Colors.black,
                    //     shape: BoxShape.circle,
                    //   ),
                    // ),
                    Container(
                      height: 50,
                      width: 3,
                      color: Palette.mainColor,
                    ),
                  ],
                ],
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  stop['station'] ?? '',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
