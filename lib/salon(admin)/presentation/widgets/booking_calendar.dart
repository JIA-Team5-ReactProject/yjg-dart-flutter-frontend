import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yjg/salon(admin)/presentation/widgets/booking_box.dart';
import 'package:yjg/shared/theme/palette.dart';

class BookingCalendar extends StatefulWidget {
  @override
  _BookingCalendarState createState() => _BookingCalendarState();
}

class _BookingCalendarState extends State<BookingCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List> _eventsList = {};
  String? _selectedStatus;
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _eventsList = {
      DateTime.now().subtract(Duration(days: 2)): ['매직펌_김정원', '물결펌_김정원'],
      DateTime.now(): ['물결펌_김정원', '매직펌_김정원', '셋팅펌_김정원', '레이어드컷_김정원'],
      DateTime.now().add(Duration(days: 1)): [
        '매직펌_김정원',
        '레이어드컷_김정원',
        '매직펌_김정원',
        '셋팅펌_김정원'
      ],
      DateTime.now().add(Duration(days: 3)):
          Set.from(['물결펌_김정원', '매직펌_김정원', '셋팅펌_김정원', '레이어드컷_김정원']).toList(),
      DateTime.now().add(Duration(days: 7)): [
        '셋팅펌_김정원',
        '레이어드컷_김정원',
        '매직펌_김정원'
      ],
      DateTime.now().add(Duration(days: 11)): ['셋팅펌_김정원', '매직펌_김정원'],
      DateTime.now().add(Duration(days: 17)): [
        '셋팅펌_김정원',
        '레이어드컷_김정원',
        '단발컷_김정원',
        '물결펌_김정원'
      ],
      DateTime.now().add(Duration(days: 22)): ['셋팅펌_김정원', '매직펌_김정원'],
      DateTime.now().add(Duration(days: 26)): [
        '레이어드컷_김정원',
        '매직펌_김정원',
        '앞머리컷_김정원'
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventsList);

    List _getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

    return Column(
      children: [
        TableCalendar(
          locale: 'ko_KR',
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          headerStyle: HeaderStyle(
            titleCentered: false,
            titleTextFormatter: (date, locale) =>
                DateFormat.yMMMMd(locale).format(date),
            formatButtonVisible: false,

            leftChevronVisible: false, // 왼쪽 화살표 버튼 숨깁.
            rightChevronVisible: false, // 오른쪽 화살표 버튼 숨깁.
            headerMargin: EdgeInsets.only(bottom: 20.0, top: 20.0, left: 20.0),
            titleTextStyle: const TextStyle(
              fontSize: 15.0,
              color: Palette.textColor,
            ),
            headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
          ),
          focusedDay: _focusedDay,
          eventLoader: _getEventForDay,
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (events.isNotEmpty) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Palette.stateColor1,
                    ),
                    width: 5.0,
                    height: 5.0,
                  ),
                );
              }
            },
            dowBuilder: (context, day) {
              // 요일 표시(주말 색상 변경)
              switch (day.weekday) {
                case 1:
                  return Center(
                    child: Text('월'),
                  );
                case 2:
                  return Center(
                    child: Text('화'),
                  );
                case 3:
                  return Center(
                    child: Text('수'),
                  );
                case 4:
                  return Center(
                    child: Text('목'),
                  );
                case 5:
                  return Center(
                    child: Text('금'),
                  );
                case 6:
                  return Center(
                    child: Text(
                      '토',
                      style: TextStyle(color: Palette.stateColor1),
                    ),
                  );
                case 7:
                  return Center(
                    child: Text(
                      '일',
                      style: TextStyle(color: Palette.stateColor3),
                    ),
                  );
              }
            },
          ),
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _getEventForDay(selectedDay);
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, top: 30.0, bottom: 15.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "예약 목록",
                  style: TextStyle(fontSize: 17.0),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 25.0),
                  child: DropdownButton<String>(
                    value: _selectedStatus,
                    icon: SizedBox.shrink(),
                    hint: Text("상태 선택",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Palette.mainColor,
                            letterSpacing: -1)),
                    underline: Container(
                      height: 0,
                    ),
                    items: <String>["접수상태", "승인상태", "거절상태"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              color: Palette.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              letterSpacing: -0.2),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStatus = newValue;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        ListView(
          shrinkWrap: true,
          children: _getEventForDay(_selectedDay!)
              .map((event) => ListTile(
                    title: BookingBox(
                      bookText: event,
                      time: "13:00",
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
