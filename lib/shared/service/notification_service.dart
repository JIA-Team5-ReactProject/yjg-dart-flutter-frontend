import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:yjg/main.dart';

// 로컬 알림 관리 클래스
class NotificationService {
  // 앱의 모든 알림을 관리하는 인스턴스(알림 발생 시 필요한 설정과 동작을 관리, 싱글톤)
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 싱글톤 팩토리 생성자(외부에서 인스턴스 요청 시 해당 인스턴스 반환)
  factory NotificationService() {
    return _instance;
  }

  // init 함수를 호출하여 알림 플러그인을 초기화
  NotificationService._internal() {
    init();
  }

  // 로컬 알림 플러그인을 초기화하는 함수, 알림 설정과 관련된 여러 초기화 작업
  // 현재, 안드로이드에서만 디버깅이 가능하므로 안드로이드만 초기화 설정, ios는 추후 검토
  Future<void> init() async {
    // 안드로이드 알림 초기화 설정
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // 알림 플러그인 초기화
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        // onDidReceiveNotificationResponse에서 NotificationResponse를 받아 처리하는 것으로 변경되었음
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
      // payload를 사용해 네비게이션 처리
      handleNotificationClick(response.payload);
    });
  }

  // payload를 사용하여 네비게이션 로직 구현
  void handleNotificationClick(String? payload) {
    if (payload != null && navigatorKey.currentState != null) {
      final data = jsonDecode(payload);
      final id = data['id'];

      switch (data['page']) {
        case 'as': // 관리자, 학생 AS(댓글 등록, AS 접수, AS 처리)
          navigatorKey.currentState!.pushNamed('/notice_detail', arguments: id);
          break;
        case 'notice': // 긴급 공지사항
          navigatorKey.currentState!.pushNamed('/notice_detail', arguments: id);
          break;
        case 'admin_salon': // 관리자 미용실 예약 확인
          navigatorKey.currentState!.pushNamed('/admin_salon_booking');
          break;
        case 'user_salon': // 사용자 미용실 예약 확인
          navigatorKey.currentState!.pushNamed('/salon_my_book');
          break;
        case 'restaurant_semester': // 학기 식수 오픈
          navigatorKey.currentState!.pushNamed('/meal_application');
          break;
        case 'restaurant_weekend': // 주말 식수 오픈
          navigatorKey.currentState!.pushNamed('/weekend_meal');
          break;
        case 'meeting': // 회의실 거절 알림
          navigatorKey.currentState!.pushNamed('/meeting_room_main');
          break;
        case 'absence': // 외박・외출 거절 알림
          navigatorKey.currentState!.pushNamed('/sleepover');
          break;
        default:
          break;
      }
    }
  }

  // 알림을 표시하는 함수, 제목과 내용을 받아 알림을 표시
  Future<void> showNotification(String title, String body,
      {String? payload}) async {
    // 안드로이드 알림 설정
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'high_importance_channel', // 채널 ID
            'High Importance Notifications', // 채널 이름
            importance: Importance.max, // 알림 중요도(max: 최대 중요도)
            priority: Priority.high, // 알림 우선순위(high: 높음)
            showWhen: true); // 알림 표시 시간 표시
    // 플랫폼별 알림 설정
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // 알림 표시
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }
}
