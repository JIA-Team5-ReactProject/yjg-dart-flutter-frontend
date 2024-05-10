import "package:flutter/material.dart";
import "package:yjg/bus/data/models/bus.dart";
import "package:yjg/bus/presentaion/widgets/bus_timeline_show_modal.dart";
import "package:yjg/shared/theme/palette.dart";

class BusScheduleCard extends StatelessWidget {
  final BusRound busRound;

  const BusScheduleCard({Key? key, required this.busRound}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firstItem = busRound.scheduleItems.first;
    final lastItem = busRound.scheduleItems.last;

    return InkWell(
     onTap: () {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // BusRound 객체를 BusTimelineShowModal에 전달
        return BusTimelineShowModal(busRound: busRound);
      },
        );
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${busRound.roundName}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Palette.textColor.withOpacity(0.5),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "${firstItem.busTime} → ${lastItem.busTime}",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Palette.mainColor),
            ),
            SizedBox(height: 8),
            Text(
              "${firstItem.station} → ${lastItem.station}",
              style: TextStyle(
                  fontSize: 16, color: Palette.textColor.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
