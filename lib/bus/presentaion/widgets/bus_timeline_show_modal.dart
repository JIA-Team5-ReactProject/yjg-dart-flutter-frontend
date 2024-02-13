import "package:flutter/material.dart";

class BusTimelineShowModal extends StatelessWidget {

  // TODO: 하드코딩
  final List<Map<String, String>> stops = [
    {'station': '영어마을', 'time': '10:00'},
    {'station': '글로벌생활관', 'time': '10:03'},
    {'station': '글로벌캠퍼스', 'time': '10:05'},
    {'station': '태전역', 'time': '10:25'},
    {'station': '복현서문', 'time': '10:45'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(40.0),
          1: FlexColumnWidth(),
          2: FixedColumnWidth(80.0),
        },
        border: TableBorder.all(color: Colors.grey),
        children: [
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('순서'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('정류장'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('도착시간'),
            ),
          ]),
          ...List<TableRow>.generate(
            stops.length,
            (index) => TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${index + 1}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(stops[index]['station'] ?? ''),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(stops[index]['time'] ?? ''),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
