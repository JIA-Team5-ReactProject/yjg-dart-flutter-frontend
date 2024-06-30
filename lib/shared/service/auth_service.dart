import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:yjg/auth/data/data_resources/login_data_source.dart';
import 'package:yjg/firebase_api.dart';
import 'package:yjg/routes/app_routes.dart';
import 'package:yjg/setting/data/data_sources/fcm_token_datasource.dart';

class AuthService {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  // fcm token getter
  Future<String?> getFcmToken() async {
    return await storage.read(key: 'fcm_token');
  }

  Future<String?> getInitialRoute() async {
    final token = await storage.read(key: 'auth_token');
    final autoLoginStr = await storage.read(key: 'auto_login') ?? 'false';
    final userType = await storage.read(key: 'userType');
    FirebaseApi firebaseApi = FirebaseApi();
    await firebaseApi.updateToken();

    debugPrint('액세스 토큰: $token');
    debugPrint('자동 로그인: $autoLoginStr');

    // ^ 토큰이 없을 경우 로그인 페이지로 이동
    if (token == null) {
      return '/login_student';
    }

    // ^ 자동로그인 미설정 시의 처리
    if (autoLoginStr == 'false') {
      if (JwtDecoder.isExpired(token)) {
        debugPrint('자동로그인 미설정, 유저 정보 삭제');
        await storage.deleteAll();
        return '/login_student';
      }

      if (!JwtDecoder.isExpired(token)) {
        final initRoute = AppRoutes.getInitialRouteBasedOnUserType(userType);
        return initRoute;
      }
    }

    // ^ 자동로그인 설정 시의 처리
    if (autoLoginStr == 'true' && (JwtDecoder.isExpired(token))) {
      // 리프레시 토큰으로 액세스 토큰 갱신
      await LoginDataSource().getRefreshTokenAPI();

      // FCM 토큰 업데이트
      await FcmTokenDataSource().patchFcmTokenAPI();

      // 갱신된 액세스 토큰으로 초기 라우터 설정
      final newToken = await storage.read(key: 'auth_token');

      // 홈 위젯을 위해 자동로그인으로 로그인이 됐을 경우, 자동로그인 성공 여부를 저장
      await storage.write(key: 'successAutoLogin', value: 'true');

      // 갱신 토큰이 null이 아니고, 만료되지 않았다면 초기 라우터 설정
      if (newToken != null && !JwtDecoder.isExpired(newToken)) {
        final initRoute = AppRoutes.getInitialRouteBasedOnUserType(userType);
        return initRoute;
      }
    }

    return AppRoutes.getInitialRouteBasedOnUserType(userType);
  }
}
