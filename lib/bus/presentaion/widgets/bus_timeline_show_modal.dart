import "package:flutter/material.dart";
import "package:yjg/bus/data/models/bus.dart";
import "package:yjg/shared/theme/palette.dart";

class BusTimelineShowModal extends StatelessWidget {
  final BusRound busRound;

  const BusTimelineShowModal({Key? key, required this.busRound})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // 모달의 최소 높이 설정
      height: MediaQuery.of(context).size.height * 0.45, // 전체 화면 높이의 50%
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text(
                "${busRound.roundName} 노선 정보",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text('도로 사정에 따라 ±10분의 차이가 있을 수 있습니다.',
                style: TextStyle(
                    fontSize: 14.0, color: Palette.textColor.withOpacity(0.6))),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                        padding: const EdgeInsets.all(8.0), child: Text('순서')),
                    Padding(
                        padding: const EdgeInsets.all(8.0), child: Text('정류장')),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('도착시간')),
                  ]),
                  ...List<TableRow>.generate(
                    busRound.scheduleItems.length,
                    (index) => TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${index + 1}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(busRound.scheduleItems[index].station),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(busRound.scheduleItems[index].busTime),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
