import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/data/models/reservation.dart';
import 'package:yjg/salon/presentaion/viewmodels/reservations_viewmodel.dart';
import 'package:yjg/salon/presentaion/widgets/my_booking_modal.dart';
import 'package:yjg/shared/theme/palette.dart';

class MyBookingList extends ConsumerStatefulWidget {
  const MyBookingList({Key? key}) : super(key: key);

  @override
  _MyBookingListState createState() => _MyBookingListState();
}

class _MyBookingListState extends ConsumerState<MyBookingList> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadReservations();
  }

  void loadReservations() async {
    Future.microtask(() async {
    // ref.refresh를 사용하여 데이터를 강제로 새로고침
    await ref.refresh(reservationsProvider.future);
    setState(() => isLoading = false);
  });
  }

  @override
  Widget build(BuildContext context) {
    final reservationsAsyncValue = ref.watch(reservationsProvider);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Palette.stateColor4));
    }

    return reservationsAsyncValue.when(
      data: (reservations) => buildReservationsList(reservations),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget buildReservationsList(List<Reservations> reservations) {
    if (reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.history_toggle_off, size: 48.0, color: Colors.grey),
            SizedBox(height: 20),
            Text("예약 이력이 없어요!",
                style: TextStyle(fontSize: 18.0, color: Colors.grey)),
          ],
        ),
      );
    } else {
      // 상태별로 예약을 그룹화하여 표시
      final Map<String, List<Reservations>> groupedReservations = {};
      for (var reservation in reservations) {
        final status = reservation.status ?? 'unknown';
        groupedReservations.putIfAbsent(status, () => []);
        groupedReservations[status]?.add(reservation);
      }

      return ListView(
        children: groupedReservations.entries.map((entry) {
          final status = entry.key;
          final reservationsForStatus = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, top: 30.0, bottom: 10.0),
                child: Text(
                  "${getStatusText(status)}된 내역이 ${reservationsForStatus.length}건 있습니다.",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
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
