import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/data/models/reservation.dart';
import 'package:yjg/salon/presentaion/viewmodels/reservations_viewmodel.dart';
import 'package:yjg/salon/presentaion/widgets/my_booking_modal.dart';
import 'package:yjg/shared/theme/palette.dart';

class MyBookingList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationsAsyncValue = ref.watch(reservationsProvider);

    return reservationsAsyncValue.when(
      data: (reservations) {
        if (reservations.isEmpty) {
          // 예약 목록이 비어있을 때 표시할 위젯
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history_toggle_off,
                  size: 48.0,
                  color: Colors.grey,
                ),
                SizedBox(height: 20),
                Text(
                  "예약 이력이 없어요!",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        } else {
          // 상태별로 예약을 그룹화
          final Map<String, List<Reservations>> groupedReservations = {};
          for (var reservation in reservations) {
            final status = reservation.status ?? 'unknown';
            groupedReservations.putIfAbsent(status, () => []);
            groupedReservations[status]?.add(reservation);
          }

          // 그룹화된 데이터를 바탕으로 위젯을 생성
          return ListView(
            children: groupedReservations.entries.map((entry) {
              final status = entry.key;
              final reservationsForStatus = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 30.0, bottom: 10.0),
                    child: Text(
                      "${getStatusText(status)}된 건(${reservationsForStatus.length})", // 상태명을 한글로 변환하는 함수 사용
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...reservationsForStatus
                      .map((reservation) =>
                          ReservationTile(reservation: reservation))
                      .toList(),
                ],
              );
            }).toList(),
          );
        }
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class ReservationTile extends ConsumerWidget {
  final Reservations reservation;

  const ReservationTile({Key? key, required this.reservation})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusText = getStatusText(reservation.status ?? '');
    return InkWell(
      onTap: () {
        myBookingModal(context, ref, reservation, reservation.status);
      },
      splashColor: Palette.mainColor.withOpacity(0.0),
      highlightColor: Palette.mainColor.withOpacity(0.0),
      focusColor: Palette.mainColor.withOpacity(0.0),
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 25.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
              color: Palette.stateColor4.withOpacity(0.3), width: 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '${reservation.salonService?.service} (${reservation.reservationDate})',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Text(
              statusText,
              style: TextStyle(
                  color: statusText == '접수'
                      ? Palette.stateColor1
                      : statusText == '승인'
                          ? Palette.stateColor2
                          : Palette.stateColor4),
            ),
          ],
        ),
      ),
    );
  }
}

String getStatusText(String status) {
  switch (status) {
    case 'submit':
      return '접수';
    case 'confirm':
      return '승인';
    case 'reject':
      return '거절';
    default:
      return '알 수 없음';
  }
}
