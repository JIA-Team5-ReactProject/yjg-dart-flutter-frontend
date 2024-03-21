import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yjg/salon/data/data_sources/admin/admin_reservation_data_source.dart';
import 'package:yjg/salon/data/models/admin_booking.dart';
import 'package:yjg/salon/domain/entities/admin_reservation.dart';
import 'package:yjg/salon/domain/usecases/admin_reservation_usecase.dart';
import 'package:yjg/salon/presentaion/viewmodels/admin_reservation_viewmodel.dart';
import 'package:yjg/salon/presentaion/viewmodels/booking_select_list_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';

enum BookingAction { confirm, reject }

void showBookingStateModal(
    BuildContext context, Reservation reservation, WidgetRef ref) {
  bool? isConfirm = true;
  final reservationUseCases =
      FetchReservationsUseCase(AdminReservationDataSource());
  final selectedDay = ref.read(selectedDateProvider);
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      BookingAction? selectedAction = BookingAction.confirm; // 기본값 설정
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Text(
                    '해당 예약건을 어떻게 하시겠습니까?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: const Text('승인하기'),
                  onTap: () {
                    setState(() {
                      selectedAction = BookingAction.confirm;
                      isConfirm = true;
                    });
                  },
                  leading: Radio<BookingAction>(
                    value: BookingAction.confirm,
                    activeColor: Palette.mainColor,
                    groupValue: selectedAction,
                    onChanged: (BookingAction? value) {
                      setState(() => {
                            selectedAction = value,
                            isConfirm = true,
                            debugPrint('isConfirm: $isConfirm')
                          });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('거절하기'),
                  onTap: () {
                    setState(() {
                      selectedAction = BookingAction.reject;
                      isConfirm = false;
                    });
                  },
                  leading: Radio<BookingAction>(
                    value: BookingAction.reject,
                    activeColor: Palette.mainColor,
                    groupValue: selectedAction,
                    onChanged: (BookingAction? value) {
                      setState(() => {
                            selectedAction = value,
                            isConfirm = false,
                          });
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      AdminReservation updateState = AdminReservation(
                        id: reservation.id,
                        status: isConfirm,
                      );
                      ReservationResult result =
                          await reservationUseCases.updateStatus(updateState);
                      debugPrint('selectedDay: $selectedDay');
                      if (result.isSuccess) {
                        ref
                            .read(reservationViewModelProvider.notifier)
                            .fetchReservations(
                                reservationDate: DateFormat('yyyy-MM-dd')
                                    .format(selectedDay ?? DateTime.now()));

                        // 성공 알림 표시
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.message),
                            backgroundColor: Palette.mainColor,
                          ),
                        );

                        // 모달 창 닫기
                        Navigator.pop(context);
                      } else {
                        // 실패 시 실패 알림 표시
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.mainColor,
                      elevation: 0,
                    ),
                    child: Text(
                      '완료',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
