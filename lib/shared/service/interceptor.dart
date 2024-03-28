import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/auth/data/data_resources/login_data_source.dart';
import 'package:yjg/shared/constants/api_url.dart';

// 토큰 로컬 스토리지에서 가져옴
final FlutterSecureStorage storage = FlutterSecureStorage();

Future<String?> getToken() async {
  return await storage.read(key: 'auth_token');
}

class DioInterceptor extends Interceptor {
  Dio dio = Dio(BaseOptions(baseUrl: apiURL));

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await getToken();
    
    // 토큰이 있을 경우 헤더에 추가
    if (token != null) {
      options.headers.addAll({
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // 401 Unauthorized이 뜨면 리프레시 토큰을 사용하여 새로운 토큰을 발급받음
      await LoginDataSource().getRefreshTokenAPI();
      // 갱신된 토큰을 사용하여 요청 재시도
      final token = await getToken(); // 갱신된 토큰 가져오기
      handler.resolve(await _retry(err.requestOptions, token));
      return;
    }
    handler.next(err);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions, String? token) async {
    final options = Options(
      method: requestOptions.method,
      headers: token != null ? {"Authorization": "Bearer $token"} : {},
    );

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
