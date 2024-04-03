import 'package:yjg/salon/data/data_sources/admin/admin_reservation_data_source.dart';
import 'package:yjg/salon/data/models/admin_booking.dart';
import 'package:yjg/salon/domain/entities/admin_reservation.dart';

class ReservationResult {
  final bool isSuccess;
  final String message;

  ReservationResult({required this.isSuccess, required this.message});
}

class FetchReservationsUseCase {
  final AdminReservationDataSource dataSource;

  FetchReservationsUseCase(this.dataSource);

  // * 예약 목록 불러오기
  Future<List<Reservation>> call(String reservationDate) async {
    final reservationsJson = await dataSource.getReservations(reservationDate);
    final List<Map<String, dynamic>> reservationsMapList =
        List<Map<String, dynamic>>.from(reservationsJson);
    return reservationsMapList
        .map<Reservation>((json) => Reservation.fromJson(json))
        .toList();
  }

  // * 예약 상태 변경하기
  Future<ReservationResult> updateStatus(AdminReservation reservation) async {
    try {
      final response = await dataSource.changeReservationState(
          reservation.id!, reservation.status!);

      if (response.statusCode == 200) {
        return ReservationResult(
            isSuccess: true, message: '미용실 예약 상태가 성공적으로 업데이트되었습니다.');
      } else {
        return ReservationResult(
            isSuccess: false, message: '미용실 예약 상태 업데이트 실패: ${response.data}');
      }
    } catch (e) {
      return ReservationResult(
          isSuccess: false, message: '미용실 예약 상태 변경 중 오류 발생 : $e');
    }
  }
}
