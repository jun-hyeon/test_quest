import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/util/service/notification_service.dart';

final fcmServiceProvider = Provider<FCMService>((ref) {
  final notificationService = ref.read(notiProvider);
  final functions = FirebaseFunctions.instanceFor(region: 'asia-northeast3');
  return FCMService(notificationService, functions);
});

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final NotificationService _notificationService;
  final FirebaseFunctions _functions;

  FCMService(this._notificationService, this._functions);

  /// FCM 초기화
  Future<void> initialize() async {
    // 권한 요청
    await _requestPermission();

    // 메시지 핸들러 설정
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // 앱 종료 상태에서 알림 탭 처리
    RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    // 토큰 갱신 리스너
    _firebaseMessaging.onTokenRefresh.listen((token) {
      log('FCM 토큰 갱신: $token');
    });
  }

  /// 알림 권한 요청
  Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('사용자 권한 상태: ${settings.authorizationStatus}');
  }

  /// FCM 토큰 가져오기
  Future<String?> getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      log('FCM 토큰: $token');
      return token;
    } catch (e) {
      log('FCM 토큰 가져오기 실패: $e');
      return null;
    }
  }

  /// 포그라운드 메시지 처리
  void _handleForegroundMessage(RemoteMessage message) {
    log('포그라운드 메시지 수신: ${message.messageId}');
    log('메시지 데이터: ${message.data}');
    log('알림 제목: ${message.notification?.title}');
    log('알림 내용: ${message.notification?.body}');

    // Notification 서비스에 위임
    _notificationService.showFCMNotification(
      id: message.hashCode,
      title: message.notification?.title ?? '새로운 알림',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
  }

  /// 알림 탭 처리
  void _handleNotificationTap(RemoteMessage message) {
    log('알림 탭됨: ${message.data}');
    _navigateToScreen(message.data);
  }

  /// 특정 화면으로 네비게이션
  void _navigateToScreen(Map<String, dynamic> data) {
    log('네비게이션 데이터: $data');

    if (data['type'] == 'new_post') {
      log('새 글 알림 - 커뮤니티 화면으로 이동');
    }
  }

  /// 토픽 구독
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      log('토픽 구독 성공: $topic');
    } catch (e) {
      log('토픽 구독 실패: $e');
    }
  }

  /// 토픽 구독 해제
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      log('토픽 구독 해제 성공: $topic');
    } catch (e) {
      log('토픽 구독 해제 실패: $e');
    }
  }

  /// 새로운 글 등록 알림 토픽 구독
  Future<void> subscribeToNewPostNotifications() async {
    await subscribeToTopic('new_posts');
  }

  /// 사용자별 토픽 구독
  Future<void> subscribeToUserTopic(String userId) async {
    await subscribeToTopic('user_$userId');
  }

  /// 사용자별 토픽 구독 해제
  Future<void> unsubscribeFromUserTopic(String userId) async {
    await unsubscribeFromTopic('user_$userId');
  }

  /// 새로운 글 등록 알림 전송
  Future<void> sendNewPostNotifications({
    required String title,
    required String platform,
    required String type,
  }) async {
    try {
      log('새로운 글 알림 전송 시작..');

      final notificationData = {
        'type': 'new_post',
        'platform': platform,
        'test_type': type,
      };

      await _sendNotification(
        topic: 'new_posts',
        title: title,
        body: '새로운 $platform $type 테스트를 등록했습니다!',
        data: notificationData,
      );

      log('새로운 글 알림 전송 완료');
    } catch (e) {
      log('새로운 글 알림 전송 실패: $e');
      rethrow;
    }
  }

  Future<void> _sendNotification({
    required String topic,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    try {
      final callable = _functions.httpsCallable('sendTopicNotification');
      final result = await callable.call<Map<String, dynamic>>({
        'topic': topic,
        'title': title,
        'body': body,
        'data': data,
      });

      log('Functions 응답: ${result.data}');
      log('FCM 알림 전송 성공');
    } on FirebaseFunctionsException catch (e) {
      log('FCM Functions 예외: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      log('FCM 알림 전송 중 오류: $e');
      rethrow;
    }
  }
}

/// 백그라운드 메시지 핸들러 (최상위 함수여야 함)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('백그라운드 메시지 수신: ${message.messageId}');
  log('백그라운드 메시지 데이터: ${message.data}');
}
