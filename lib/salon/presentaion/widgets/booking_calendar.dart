import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yjg/salon/data/data_sources/booking_data_source.dart';
import 'package:yjg/salon/data/models/business_hours.dart';
import 'package:yjg/salon/presentaion/viewmodels/booking_business_hours_viewmodel.dart';
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
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(Duration(days: 31)),
          headerStyle: HeaderStyle(
            titleCentered: false,
            titleTextFormatter: (date, locale) =>
                DateFormat.yMMMMd(locale).format(date),
            formatButtonVisible: false,
            leftChevronVisible: false,
            rightChevronVisible: false,
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
              final String formattedDate =
                  DateFormat('yyyy-MM-dd').format(selectedDay);
              ref.read(selectedDateProvider.notifier).state = selectedDay;
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              // 선택된 날짜를 기반으로 영업 시간을 불러오는 함수 호출
              ref.refresh(salonHoursProvider(formattedDate));
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
