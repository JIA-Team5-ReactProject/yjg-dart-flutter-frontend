import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class MeetingRoomDataSource {
  static final storage = FlutterSecureStorage();
  static final Dio dio = Dio();

  MeetingRoomDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * 최신 예약 정보 가져오기
  Future<Response> fetchLatestReservation() async {
    String url = '$apiURL/api/meeting-room/reservation/user';

    try {
      final response = await dio.get(url);
      return response;
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('최신 예약 정보를 불러오지 못했습니다.');
    }
  }

  // * 해당 회의실 마다의 예약 된 시간 목록을 받아오는 API
  Future<Response> fetchReservedTimes(String roomNumber, DateTime date) async {
    final String dateString =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final numericRoomNumber =
        roomNumber.replaceAll(RegExp(r'[^0-9]'), ''); // 호실 번호에서 숫자 부분만 추출

    String url =
        '$apiURL/api/meeting-room/check?date=$dateString&room_number=$numericRoomNumber';

    try {
      final response = await dio.get(url);

      return response;
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('예약된 시간을 불러오지 못했습니다.');
    }
  }

  // * 회의실의 목록을 받아오는 API
  Future<Response> fetchMeetingRooms() async {
    String url = '$apiURL/api/meeting-room';

    try {
      final response = await dio.get(url);
      return response;
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('회의실 목록을 불러오지 못했습니다.');
    }
  }

  // * 예약을 위한 함수 추가
  Future<Response> makeReservation(
      roomNumber, reservationDate, reservvationSTime, reservationETime) async {
    final url = '$apiURL/api/meeting-room/reservation';
    final data = {
      'meeting_room_number': roomNumber,
      'reservation_date': reservationDate,
      'reservation_s_time': reservvationSTime,
      'reservation_e_time': reservationETime,
    };

    try {
      final response = await dio.post(url, data: data);
      return response;
    } catch (e) {
      debugPrint('Error: $e');
      throw Exception('예약을 등록하지 못했습니다.');
    }
  }

  // * API 통신 함수 (회의실 카드에 쓸 데이터 불러오기)
  Future<Response> fetchASRequests() async {
    String url = '$apiURL/api/meeting-room/reservation/user';
    try {
      final response = await dio.get(url);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch reservations. Error: $e');
    }
  }

  // * 예약 삭제 API 통신 함수
  Future<void> deleteReservation(int reservationId) async {
    String url = '$apiURL/api/meeting-room/reservation/$reservationId';

    try {
      final response = await dio.delete(url);
      debugPrint('통신 결과: $response 통신 코드: ${response.statusCode}');
    } catch (e) {
      debugPrint('Failed to delete reservation. Error: $e');
    }
  }
}
