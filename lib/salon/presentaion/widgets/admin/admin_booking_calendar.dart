import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yjg/salon/presentaion/viewmodels/admin_reservation_viewmodel.dart';
import 'package:yjg/salon/presentaion/widgets/admin/empty_bookings.dart';
import 'package:yjg/salon/presentaion/widgets/admin/reservation_info_list.dart';
import 'package:yjg/shared/theme/palette.dart';

class AdminBookingCalendar extends ConsumerStatefulWidget {
  const AdminBookingCalendar({super.key});

  @override
  _AdminBookingCalendarState createState() => _AdminBookingCalendarState();
}

class _AdminBookingCalendarState extends ConsumerState<AdminBookingCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List> _eventsList = {};
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reservationViewModelProvider.notifier).fetchReservations(
          reservationDate:
              DateFormat('yyyy-MM-dd').format(_selectedDay ?? _focusedDay));
    });
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
              return null;
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
              ref.read(reservationViewModelProvider.notifier).fetchReservations(
                  reservationDate:
                      DateFormat('yyyy-MM-dd').format(selectedDay));
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 30.0, bottom: 15.0),
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final reservationAsyncValue =
                        ref.watch(reservationViewModelProvider);
                    return reservationAsyncValue.when(
                      data: (reservations) {
                        if (reservations.isEmpty) {
                          return EmptyBookings(); // 예약 목록이 비었을 때 보여줄 위젯
                        } else {
                          // 상태별로 예약 목록 분류
                          final submitReservations = reservations
                              .where((r) => r.status == 'submit')
                              .toList();
                          final confirmReservations = reservations
                              .where((r) => r.status == 'confirm')
                              .toList();
                          final rejectReservations = reservations
                              .where((r) => r.status == 'reject')
                              .toList();

                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (submitReservations.isNotEmpty) ...[
                                  Text('접수된 예약',
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold)),
                                  ...submitReservations
                                      .map((reservation) => ReservationInfoList(
                                          reservation: reservation))
                                      .toList(),
                                  Divider(),
                                ],
                                if (confirmReservations.isNotEmpty) ...[
                                  Text('승인한 예약',
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold)),
                                  ...confirmReservations
                                      .map((reservation) => ReservationInfoList(
                                          reservation: reservation))
                                      .toList(),
                                  Divider(),
                                ],
                                if (rejectReservations.isNotEmpty) ...[
                                  Text('거절한 예약',
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold)),
                                  ...rejectReservations
                                      .map((reservation) => ReservationInfoList(
                                          reservation: reservation))
                                      .toList(),
                                ],
                              ],
                            ),
                          );
                        }
                      },
                      loading: () => Center(
                          child: CircularProgressIndicator(
                              color: Palette.stateColor4)),
                      error: (error, stack) => Text('Error: $error'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
