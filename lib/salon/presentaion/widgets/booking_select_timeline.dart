import "package:flutter/material.dart";
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:yjg/shared/theme/palette.dart';

class BookingSelectTimeline extends StatefulWidget {
  BookingSelectTimeline({super.key});

  @override
  State<BookingSelectTimeline> createState() => _BookingSelectTimelineState();
}

class _BookingSelectTimelineState extends State<BookingSelectTimeline> {
  DatePickerController dp = DatePickerController();
  DateTime _selectedValue = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      DatePicker(
        DateTime.now(),
        height: 100,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.black,
        selectedTextColor: Colors.white,
        locale: 'ko_KR',
        onDateChange: (date) {
          setState(() {
            _selectedValue = date;
          });
        },
      ),
    ],
);
  }
}
