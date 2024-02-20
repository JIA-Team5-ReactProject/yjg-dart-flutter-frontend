import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

List<String> selectedTimes = []; // 선택된 시간대를 저장하는 상태 변수

class MeetingRoomTime extends StatefulWidget {
  //시간대 예약 가능 여부
  final bool? booking_time;

  const MeetingRoomTime({super.key, this.booking_time});

  @override
  State<MeetingRoomTime> createState() => _MeetingRoomTimeState();
}

class _MeetingRoomTimeState extends State<MeetingRoomTime> {
  @override
  Widget build(BuildContext context) {
    if (widget.booking_time == false) {
      return GroupButton(
        isRadio: false,
        onSelected: (index, isSelected, isPressed) {
          if (isSelected == 0) {
            setState(() {
              if (selectedTimes.contains('12:00')) {
                // 리스트에 이미 있다면 삭제.
                selectedTimes.remove('12:00');
              } else {
                // 리스트에 없다면 추가.
                selectedTimes.add('12:00');
              }
            });
          } else if (isSelected == 1) {
            setState(() {
              if (selectedTimes.contains('13:00')) {
                // 리스트에 이미 있다면 삭제.
                selectedTimes.remove('13:00');
              } else {
                // 리스트에 없다면 추가.
                selectedTimes.add('13:00');
              }
            });
          } else if (isSelected == 2) {
            setState(() {
              if (selectedTimes.contains('14:00')) {
                // 리스트에 이미 있다면 삭제.
                selectedTimes.remove('14:00');
              } else {
                // 리스트에 없다면 추가.
                selectedTimes.add('14:00');
              }
            });
          } else if (isSelected == 3) {
            setState(() {
              if (selectedTimes.contains('15:00')) {
                // 리스트에 이미 있다면 삭제.
                selectedTimes.remove('15:00');
              } else {
                // 리스트에 없다면 추가.
                selectedTimes.add('15:00');
              }
            });
          } else if (isSelected == 4) {
            setState(() {
              if (selectedTimes.contains('16:00')) {
                // 리스트에 이미 있다면 삭제.
                selectedTimes.remove('16:00');
              } else {
                // 리스트에 없다면 추가.
                selectedTimes.add('16:00');
              }
            });
          } else if (isSelected == 5) {
            setState(() {
              if (selectedTimes.contains('17:00')) {
                // 리스트에 이미 있다면 삭제.
                selectedTimes.remove('17:00');
              } else {
                // 리스트에 없다면 추가.
                selectedTimes.add('17:00');
              }
            });
          } else if (isSelected == 6) {
            setState(() {
              if (selectedTimes.contains('18:00')) {
                // 리스트에 이미 있다면 삭제.
                selectedTimes.remove('18:00');
              } else {
                // 리스트에 없다면 추가.
                selectedTimes.add('18:00');
              }
            });
          } else if (isSelected == 7) {
            setState(() {
              if (selectedTimes.contains('19:00')) {
                // 리스트에 이미 있다면 삭제.
                selectedTimes.remove('19:00');
              } else {
                // 리스트에 없다면 추가.
                selectedTimes.add('19:00');
              }
            });
          }
        },
        buttons: [
          "12:00",
          "13:00",
          "14:00",
          "15:00",
          "16:00",
          "17:00",
          "18:00",
          "19:00"
        ],
      );
    } else {
      return Text('예약x');
    }
  }
}
