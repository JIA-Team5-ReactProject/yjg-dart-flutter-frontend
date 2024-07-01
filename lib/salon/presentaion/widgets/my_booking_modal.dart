import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yjg/salon/data/data_sources/booking_data_source.dart';
import 'package:yjg/salon/data/models/reservation.dart';
import 'package:yjg/salon/domain/usecases/reservation_usecase.dart';
import 'package:yjg/salon/presentaion/viewmodels/reservations_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';

void myBookingModal(BuildContext context, WidgetRef ref,
    Reservations reservation, String? status) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'salon.myBookingList.bookingModal.title'.tr(),
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Divider(
              color: Palette.stateColor4.withOpacity(0.3),
              thickness: 0.5,
              height: 20.0,
            ),
            SizedBox(height: 10.0),
            // 서비스명
            _buildModalRow('salon.myBookingList.bookingModal.service'.tr(), reservation.salonService?.service ?? 'N/A'),
            SizedBox(height: 10.0),
            // 가격
            _buildModalRow(
                'salon.myBookingList.bookingModal.price'.tr(), '${reservation.salonService?.price ?? 'N/A'}원'),
            SizedBox(height: 10.0),
            // 날짜와 시간
            _buildModalRow('salon.myBookingList.bookingModal.dateTime'.tr(),
                '${reservation.reservationDate ?? 'N/A'} ${reservation.reservationTime ?? ''}'),
            SizedBox(height: 10.0),
            // 상태
            _buildModalRow('salon.myBookingList.bookingModal.state'.tr(), getStatusText(reservation.status ?? '')),
            SizedBox(height: 10.0),
            if (status == 'submit')
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () async {
                    final confirmDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('salon.myBookingList.bookingModal.cancelButton'.tr(),
                            style: TextStyle(
                                color: Palette.textColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600)),
                        content: Text('salon.myBookingList.bookingModal.cancelModal.description').tr(),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('salon.myBookingList.bookingModal.cancelModal.noButton'.tr(),
                                style: TextStyle(
                                    color: Palette.stateColor4,
                                    fontWeight: FontWeight.w600)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('salon.myBookingList.bookingModal.cancelModal.yesButton'.tr(),
                                style: TextStyle(
                                    color: Palette.stateColor3,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    );

                    if (confirmDelete == true) {
                      final bookingDataSource = BookingDataSource();
                      final reservationUseCase =
                          ReservationUseCase(bookingDataSource);

                      // 예약 취소 메서드 호출
                      await reservationUseCase.cancelReservation(
                          reservation.id ?? 0, context);

                      // 예약 취소 후 목록 리프레시
                      ref.refresh(reservationsProvider);
                    }
                  },
                  child: Text(
                    'salon.myBookingList.bookingModal.cancelButton'.tr(),
                    style: TextStyle(color: Palette.stateColor3),
                  ),
                ),
              ),
            SizedBox(height: 50.0),
          ],
        ),
      );
    },
  );
}

// 모달 내에서 반복되는 Row 위젯을 구성하는 함수
Widget _buildModalRow(
  String title,
  String? value,
) {
  // 가격 정보를 천 단위 구분자로 포맷
  if (title == '가격' && value != null && value != 'N/A') {
    final number =
        double.tryParse(value.replaceAll('원', '').replaceAll(',', ''));
    if (number != null) {
      value = NumberFormat('#,##0', 'ko_KR').format(number) + '원';
    }
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        value ?? 'N/A',
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
    ],
  );
}
