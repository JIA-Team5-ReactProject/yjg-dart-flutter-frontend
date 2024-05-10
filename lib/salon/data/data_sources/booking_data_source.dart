import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class BookingDataSource {
  static final Dio dio = Dio();
  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  BookingDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * 영업시간 목록 불러오기
  Future<Response> getSalonHourAPI(String day) async {
    String url = '$apiURL/api/salon/hour/$day';

    try {
      final response = await dio.get(url);

      return response;
    } catch (e) {
      throw Exception('영업시간을 불러오지 못했습니다.');
    }
  }

  // * 예약하기
  Future<Response> postReservationAPI(
      int serviceId, String reservationDate, String reservationTime) async {
    String url = '$apiURL/api/salon/reservation';

    final data = {
      'salon_service_id': serviceId,
      'reservation_date': reservationDate,
      'reservation_time': reservationTime
    };

    try {
      final response = await dio.post(url, data: data);

      return response;
    } catch (e) {
      throw Exception('예약에 실패하였습니다.');
    }
  }

  // * 예약 취소
  Future<bool> deleteReservationAPI(int reservationId) async {
    String url = '$apiURL/api/salon/reservation/$reservationId';
    try {
      await dio.delete(url);

      return true;
    } catch (e) {
      throw Exception('예약 취소에 실패하였습니다.');
    }
  }
}
