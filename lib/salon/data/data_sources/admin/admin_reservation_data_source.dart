import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class AdminReservationDataSource {
  static final Dio dio = Dio();
  static final storage = FlutterSecureStorage(); // 토큰 담는 곳

  AdminReservationDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * 예약 목록 불러오기
  Future<List<dynamic>> getReservations(String reservationDate) async {
    String url = '$apiURL/api/salon/reservation?r_date=$reservationDate';

    try {
      final response = await dio.get(url);
      return response.data['reservations'];
    } catch (e) {
      debugPrint('통신 결과: $e');
      throw Exception('예약 목록을 불러오는데 실패했습니다.');
    }
  }

  // * 예약 상태 변경하기
  Future<Response> changeReservationState(
      int reservationId, bool isConfirm) async {
    String url = '$apiURL/api/salon/reservation';
    final data = {
      'id': reservationId,
      'status': isConfirm,
    };

    try {
      final response = await dio.patch(url, data: data);
      return response;
    } on DioException catch (e) {
      debugPrint('코드: ${e.response!.statusCode} 데이터: ${e.response!.data}');
      throw Exception('예약 상태 변경에 실패했습니다. : $e');
    } catch (e) {
      debugPrint('통신 결과: $e');
      throw Exception('예약 상태 변경에 실패했습니다.');
    }
  }
}
