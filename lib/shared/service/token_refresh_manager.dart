
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:yjg/auth/data/data_resources/login_data_source.dart';
import 'package:yjg/shared/service/interceptor.dart';

// 토큰 갱신 로직을 중앙에서 관리하는 싱글톤 클래스, 동시에 여러 API 호출이 발생할 때 
// 중복된 토큰 갱신 요청을 방지하기 위해 사용

class TokenRefreshManager {
  // TokenRefreshManager의 싱글톤 인스턴스를 저장
  static final TokenRefreshManager _instance = TokenRefreshManager._internal();
  
  // 토큰 갱신 요청 진행 여부
  bool _isRefreshing = false;
  
  // 토큰 갱신 요청이 진행 중일 때 대기 상태에 있는 모든 요청을 저장
  // 각 요소는 새 토큰으로 요청을 재시도할 수 있는 함수
  final List<Function(String)> _waitingRequests = [];

  // factory 생성자를 통해 클래스의 싱글톤 인스턴스에 접근 가능
  factory TokenRefreshManager() {
    return _instance;
  }

  // 싱글톤 인스턴스 초기화
  TokenRefreshManager._internal();

  // 토큰 갱신이 이미 되고 있지 않은 경우에만 토큰 갱신 로직을 실행
  // 토큰 갱신이 필요한 경우 모든 대기 중인 요청 -> 새 토큰이 발급될 때까지 대기 상태가 됨
  Future<void> refreshTokenIfNeeded(RequestOptions requestOptions, Dio dio) async {
    if (!_isRefreshing) {
      _isRefreshing = true;
      try {
        // 액세스 토큰 업데이트 API
        String newToken = await LoginDataSource().getRefreshTokenAPI();
        await storage.write(key: 'auth_token', value: newToken);
        // 대기 중인 모든 요청에 새 토큰을 적용, 처리
        _processWaitingRequests(newToken);
      } finally {
        _isRefreshing = false;
      }
    } else {
      // 토큰 갱신 요청이 이미 진행 중이면 요청을 대기 리스트에 추가
      final completer = Completer<void>();
      _waitingRequests.add((token) {
        requestOptions.headers["Authorization"] = "Bearer $token";
        completer.complete();
      });
      return completer.future;
    }
  }

  // 새 토큰이 발급된 후 대기 중인 모든 요청을 처리
  // 대기 중인 요청에 토근을 적용하고, 대기 리스트를 비움
  void _processWaitingRequests(String newToken) {
    for (var request in _waitingRequests) {
      request(newToken);
    }
    _waitingRequests.clear();
  }
}
