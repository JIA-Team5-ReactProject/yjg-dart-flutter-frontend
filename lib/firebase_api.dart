import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// 백그라운드에서 받은 메시지를 처리하는 함수
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint('mattabu: Title: ${message.notification?.title}');  // 메시지 제목 출력
  debugPrint('mattabu: Body: ${message.notification?.title}');   // 메시지 내용 출력
  debugPrint('mattabu: Payload: ${message.data}');               // 메시지 데이터 출력
}

class FirebaseApi {
  // Firebase 메시징 인스턴스 생성
  final _firebaseMessaging = FirebaseMessaging.instance;

  // 알림 초기화 함수
  Future<void> initNotifications() async {
    // 사용자로부터 알림 권한 요청 (사용자에게 권한 요청 창을 띄움)
    await _firebaseMessaging.requestPermission(
      badge: true,  // 배지 허용
      alert: true,  // 알림 허용
      sound: true   // 소리 허용
    );

    // 백그라운드 메시지 처리 설정
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // 이 디바이스의 FCM 토큰 획득
    final FCMToken = await _firebaseMessaging.getToken();

    // 토큰 출력
    debugPrint('Token: $FCMToken');
  }
}
