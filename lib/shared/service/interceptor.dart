import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/auth/data/data_resources/login_data_source.dart';

final FlutterSecureStorage storage = FlutterSecureStorage();

// 토큰 로컬 스토리지에서 가져옴
Future<String?> getToken() async {
  return await storage.read(key: 'auth_token');
}

// 요청, 응답, 에러에 대한 인터셉터
class DioInterceptor extends Interceptor {
  final Dio dio;

  // 생성자에서 Dio 인스턴스를 받음
  DioInterceptor(this.dio);

  @override
  // 요청 전송 전에 요청을 가로채고 처리
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // 인증 토큰을 가져옴
    final token = await getToken();

    // 토큰이 있을 경우 헤더에 추가
    if (token != null) {
      options.headers.addAll({
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });
    }
    // 요청을 계속 진행
    return super.onRequest(options, handler);
  }

  @override
  // 응답 처리 메서드
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 기본 응답 처리를 계속 진행
    super.onResponse(response, handler);
  }

  @override
  // 에러 처리 메서드
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 Unauthorized 에러가 발생했을 경우
    if (err.response?.statusCode == 401) {
      // 새 토큰을 얻기 위해 getRefreshTokenAPI 호출
      await LoginDataSource().getRefreshTokenAPI();
      // 갱신된 토큰을 사용하여 요청 재시도
      final token = await getToken(); // 갱신된 토큰 가져오기
      handler.resolve(await _retry(err.requestOptions, token));
    }
    // 에러 처리를 계속 진행
    handler.next(err);
  }

  // 새 토큰을 사용하여 요청 재시도
  Future<Response<dynamic>> _retry(
      RequestOptions requestOptions, String? token) async {
    const maxRetryCount = 3; // 최대 재시도 횟수
    requestOptions.headers["Authorization"] = "Bearer $token";

    // 재시도 횟수를 가져와서 1 증가
    int retryCount = requestOptions.extra["retryCount"] ?? 0;
    if (retryCount >= maxRetryCount) {
      throw Exception("재시도 횟수 초과");
    }
    requestOptions.extra["retryCount"] = retryCount + 1;

    // Dio 인스턴스를 사용하여 요청 재시도
    return dio.request<dynamic>(
      requestOptions.path,
      options: Options(
          method: requestOptions.method, headers: requestOptions.headers),
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );
  }
}
