import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/salon/data/models/admin_booking.dart';
import 'package:yjg/salon/presentaion/widgets/admin/show_booking_state_modal.dart';
import 'package:yjg/shared/theme/palette.dart';

class ReservationInfoList extends ConsumerWidget {
  final Reservation reservation;

  const ReservationInfoList({Key? key, required this.reservation})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        showBookingStateModal(context, reservation, ref);
      },
      splashColor: Palette.stateColor4.withOpacity(0.0),
      highlightColor: Palette.stateColor4.withOpacity(0.0),
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Container(
          // 전체 화면 가로 길이의 80%
          width: MediaQuery.of(context).size.width * 0.85,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          margin: EdgeInsets.only(bottom: 5.0),
          decoration: BoxDecoration(
            color: reservation.status == 'reject'
                ? Palette.stateColor4.withOpacity(0.05)
                : Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5.0,
                width: 100.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${reservation.serviceName}_${reservation.userName}',
                      style: TextStyle(
                          fontSize: 14.0,
                          color: reservation.status == 'reject'
                              ? Palette.stateColor4
                              : Colors.black)),
                  Text(reservation.reservationTime,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: reservation.status == 'submit'
                              ? Palette.stateColor1
                              : reservation.status == 'confirm'
                                  ? Palette.stateColor2
                                  : Palette.stateColor4)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
