import "package:flutter/material.dart";
import "package:yjg/shared/theme/palette.dart";

class BusTimelineShowModal extends StatelessWidget {
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
                    style: TextStyle(
                        fontSize: 13,
                        color: Palette.mainColor,
                        fontWeight: FontWeight.bold),
                  ),
                  if (!isLastStop) ...[
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
