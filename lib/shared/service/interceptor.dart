import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/service/token_refresh_manager.dart';

final FlutterSecureStorage storage = FlutterSecureStorage();

// 토큰 로컬 스토리지에서 가져옴
Future<String?> getToken() async {
  return await storage.read(key: 'auth_token');
}

// 리프레시 토큰 로컬 스토리지에서 가져옴
Future<String?> getRefreshToken() async {
  return await storage.read(key: 'refresh_token');
}

// 요청, 응답, 에러에 대한 인터셉터
class DioInterceptor extends Interceptor {
  final Dio dio;

  // 생성자에서 Dio 인스턴스를 받음
  DioInterceptor(this.dio);

  @override
  // 요청 전송 전에 요청을 가로채고 처리
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.data is FormData) {
      // 폼 데이터 요청인 경우
      options.headers["Content-Type"] = "multipart/form-data";
    } else {
      // JSON 요청인 경우 (기본)
      options.headers["Content-Type"] = "application/json";
    }

    // 리프레시 토큰 사용이 필요한 경우
    if (options.extra["useRefreshToken"] == true) {
      final refreshToken = await getRefreshToken();
      if (refreshToken != null) {
        options.headers["Authorization"] = "Bearer $refreshToken";
      }
    } else if (options.extra["noAuth"] != true) {
      // 일반적인 액세스 토큰 사용 경우
      final token = await getToken();
      if (token != null) {
        options.headers["Authorization"] = "Bearer $token";
      }
    }

    return super.onRequest(options, handler);
  }

  @override
  // 응답 처리 메서드
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 기본 응답 처리를 계속 진행
    super.onResponse(response, handler);
  }

  @override
  // 에러 발생 시 실행되는 메서드
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 Unauthorized 에러 처리
    if (err.response?.statusCode == 401 &&
        err.requestOptions.extra["noAuth"] != true) {
      try {
        // TokenRefreshManager를 사용하여 토큰 리프레시 로직 실행
        await TokenRefreshManager()
            .refreshTokenIfNeeded(err.requestOptions, dio);
        // 토큰이 갱신된 후 요청 재시도
        final response = await _retry(err.requestOptions);
        handler.resolve(response);
      } catch (e) {
        // 재시도에 실패하거나 리프레시 토큰 자체가 실패한 경우
        super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }

  // 새 토큰을 사용하여 요청 재시도
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    const maxRetryCount = 3; // 최대 재시도 횟수
    final token = await getToken(); // 새 토큰 가져오기

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
