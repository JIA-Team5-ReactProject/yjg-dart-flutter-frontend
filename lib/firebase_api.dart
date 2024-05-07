import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/shared/service/notification_service.dart';

class FirebaseApi {
  // 메시지 수신을 위한 FirebaseMessaging 인스턴스 생성
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final storage = FlutterSecureStorage(); // FCM 토큰 저장

  // 알림 기능 초기화
  Future<void> initNotifications() async {
    // 권한 관리
    await _firebaseMessaging.requestPermission(
      badge: true, // 배지 권한
      alert: true, // 알림 권한
      sound: true, // 소리 권한
    );

    // 포그라운드 메시지 처리
    FirebaseMessaging.onMessage.listen(_firebaseMessageHandler);

    // 백그라운드 메시지 처리
    FirebaseMessaging.onBackgroundMessage(_firebaseMessageHandler);

    // Firebase에서 제공하는 토큰 가져오기(디바이스 식별용)
    String? fcmToken = await _firebaseMessaging.getToken();
    await storage.write(key: 'fcm_token', value: fcmToken);
    debugPrint('FCM 토큰: $fcmToken');
  }

  // 포그라운드, 백그라운드 메시지 처리 핸들러
  static Future<void> _firebaseMessageHandler(RemoteMessage message) async {
    // 로그인 했을 경우에만 옴(로그아웃 시에는 토큰이 삭제되기 때문)
    if (message.notification != null) {
      final title = message.notification!.title ?? "No Title";
      final body = message.notification!.body ?? "No Body";
      final payload = jsonEncode(message.data); // 알림과 함께 전달할 추가 데이터

      debugPrint('onMessage: $title / $body / $payload');

      await NotificationService()
          .showNotification(title, body, payload: payload);
    }
  }
}
