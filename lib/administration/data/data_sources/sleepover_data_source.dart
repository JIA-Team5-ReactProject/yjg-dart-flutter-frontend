import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:yjg/shared/constants/api_url.dart';
import 'package:yjg/shared/service/interceptor.dart';

class SleepoverDataSource {
  static final storage = FlutterSecureStorage();
  static final Dio dio = Dio();

  SleepoverDataSource() {
    dio.interceptors.add(DioInterceptor(dio));
  }

  // * 외박/외출 신청하는 POST API 함수
  Future<Response> submitApplication(DateTime? _startDate, DateTime? _endDate,
      TextEditingController _reasonController, String type) async {
    String url = '$apiURL/api/absence';
    final data = {
      'start_date': DateFormat('yyyy-MM-dd').format(_startDate!),
      'end_date': DateFormat('yyyy-MM-dd').format(_endDate!),
      'content': _reasonController.text,
      'type': type,
    };

    try {
      final response = await dio.post(url, data: data);
      return response;
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw DioException(
          requestOptions: e.requestOptions,
          error: '이미 신청된 날짜입니다.',
          response: e.response,
        );
      } else {
        throw DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          error: '외박/외출 신청을 실패하였습니다.',
        );
      }
    } catch (e) {
      throw Exception('예기치 못한 오류가 발생하였습니다.');
    }
  }

  // * 외박/외출 신청 정보 불러오는 GET API 함수
  Future<Response> fetchSleepoverApplications() async {
    String url = '$apiURL/api/absence/user';

    try {
      final response = await dio.get(url);
      debugPrint('외박/외출 불러오기 완료: ${response.statusCode}, ${response.data}');
      return response;
    } catch (e) {
      throw Exception('예약 불러오기를 실패하였습니다.');
    }
  }

  // * 외박/외출 신청 취소하는 DELETE API 함수
  Future<void> deleteApplication(int id) async {
    final url = '$apiURL/api/absence/$id';

    try {
      final response = await dio.delete(url);
      debugPrint('예약 취소 완료: ${response.statusCode}');
    } catch (e) {
      throw Exception('예약 취소를 실패하였습니다.');
    }
  }
}
