import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yjg/salon/data/data_sources/booking_data_source.dart';
import 'package:yjg/salon/domain/usecases/reservation_usecase.dart';
import 'package:yjg/salon/presentaion/viewmodels/booking_select_list_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';

void bookingExecutionModal(BuildContext context, WidgetRef ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  String? formattedDate;

  if (selectedDate != null) {
    formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    final selectedTimeSlot = ref.watch(selectedTimeSlotProvider);
    final selectedServiceName = ref.watch(selettedServiceNameProvider);
    final selectedServiceId = ref.watch(selectedServiceIdProvider);
    final bookingDataSource = BookingDataSource(); // DataSource 인스턴스화
    final reservationUseCase = ReservationUseCase(bookingDataSource);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 120,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          selectedServiceName,
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Row(children: [
                          Text(
                            formattedDate ?? "Unknown Date",
                            style: TextStyle(
                                fontSize: 14.0, color: Palette.mainColor),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            selectedTimeSlot ?? "Unknown TimeSlot",
                            style: TextStyle(
                                fontSize: 14.0, color: Palette.mainColor),
                          ),
                        ])
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          backgroundColor: Palette.mainColor // 버튼 색상 지정
                          ),
                      onPressed: () async {
                        try {
                          await reservationUseCase.createReservation(
                              selectedServiceId,
                              formattedDate!,
                              selectedTimeSlot!, context);
                   
                        } catch (error) {
                          debugPrint('Error: $error');
                        }
                      },
                      child: Text(
                        '예약',
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
