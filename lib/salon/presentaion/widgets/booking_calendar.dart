import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yjg/salon/presentaion/viewmodels/booking_select_list_viewmodel.dart';
import 'package:yjg/salon/presentaion/widgets/time_slots_grid.dart';
import 'package:yjg/shared/theme/palette.dart';

class BookingCalendar extends ConsumerStatefulWidget {
  @override
  _BookingCalendarState createState() => _BookingCalendarState();
}

class _BookingCalendarState extends ConsumerState<BookingCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List> _eventsList = {};

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _eventsList = {};
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
          // 오늘 날짜부터 선택 가능
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(Duration(days: 31)),
          headerStyle: HeaderStyle(
            titleCentered: false,
            titleTextFormatter: (date, locale) =>
                DateFormat.yMMMMd(locale).format(date),
            formatButtonVisible: false, // 월간/주간 버튼 비활성화
            leftChevronVisible: false, // 왼쪽 화살표 버튼 비활성화
            rightChevronVisible: false, // 오른쪽 화살표 버튼 비활성화
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
            if (!isSameDay(
                ref.read(selectedDateProvider.notifier).state, selectedDay)) {
              ref.read(selectedDateProvider.notifier).state = selectedDay;
              debugPrint('선택: ${ref.watch(selectedDateProvider)}');
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
          padding: EdgeInsets.only(top: 30.0, bottom: 15.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "3. 선택한 날짜의 시간을 선택해주세요.",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        TimeSlotsGrid(),
      ],
    );
  }
}
