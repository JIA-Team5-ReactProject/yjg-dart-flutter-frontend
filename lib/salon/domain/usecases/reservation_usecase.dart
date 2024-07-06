import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/salon/data/data_sources/booking_data_source.dart';
import 'package:yjg/salon/presentaion/viewmodels/booking_select_list_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';

class ReservationUseCase {
  final BookingDataSource _bookingDataSource;
  static final storage = FlutterSecureStorage();
  ReservationUseCase(this._bookingDataSource);

  // * API 통신
  Future<void> createReservation(int serviceId, String reservationDate,
      String reservationTime, BuildContext context, WidgetRef ref) async {
    try {
      final response = await _bookingDataSource.postReservationAPI(
          serviceId, reservationDate, reservationTime);

      // 예약 생성 API 호출 결과 처리
      if (response.statusCode == 201) {
        // 예약 시간 초기화
        ref.read(selectedTimeSlotProvider.notifier).state = null;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('salon.salonBooking.isSuccess'.tr()),
              backgroundColor: Palette.mainColor),
        );
        Navigator.pushNamed(
          context,
          '/salon_main',
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('salon.salonBooking.isFailed'.tr()), backgroundColor: Colors.red),
        );
        throw Exception('예약에 실패했습니다. 다시 시도해주세요.');
      }
    } catch (e) {
      // API 호출 중 에러 처리
      debugPrint('API 호출 중 오류 발생: $e');
      throw Exception('API 호출 중 오류 발생: $e');
    }
  }

  // * 예약 취소 기능 추가
  Future<void> cancelReservation(
      int reservationId, BuildContext context) async {
    try {
      final isSuccess =
          await _bookingDataSource.deleteReservationAPI(reservationId);

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('salon.myBookingList.cancelSuccess'.tr()),
              backgroundColor: Palette.mainColor),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('salon.myBookingList.cancelFailed'.tr()), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      // API 호출 중 에러 처리
      debugPrint('예약 취소 중 오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('salon.myBookingList.cancelError').tr(), backgroundColor: Colors.red),
      );
    }
  }
}

// * 예약 상태 텍스트 변환
String getStatusText(String status) {
  switch (status) {
    case 'submit':
      return '접수';
    case 'confirm':
      return '승인';
    case 'reject':
      return '거절';
    default:
      return '알 수 없음'; // 기본값 처리
  }
}
