import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalNotification {
  // 플러그인 인스턴스 생성
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // 푸시 알림 스트림 생성
  static final StreamController<String?> notificationStream =
  StreamController<String?>.broadcast();

  // 푸시 알림 탭 했을 때 호출되는 함수
  static void onNotificationTap(NotificationResponse notificationResponse) async {
    final String payload = notificationResponse.payload ?? "";

    // 알림을 클릭했을 때 SharedPreferences 상태 업데이트
    final prefs = await SharedPreferences.getInstance();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // 사용자별 알림 로드
    List<String>? storedNotifications = prefs.getStringList('notifications_$userId');

    if (storedNotifications != null) {
      // 알림을 읽음으로 상태 변경
      List<String> updatedNotifications = storedNotifications.map((notification) {
        if (notification.contains(payload)) {
          return notification.replaceAll('unread', 'read');
        }
        return notification;
      }).toList();

      // 업데이트된 알림 저장
      prefs.setStringList('notifications_$userId', updatedNotifications);
    }

    notificationStream.add(payload);  // 클릭된 알림의 payload 추가
  }

  // 플러그인 초기화
  static Future init() async {
    // 안드로이드 알람 이미지 세팅
    const AndroidInitializationSettings initializationSettingAndroid =
    AndroidInitializationSettings("@mipmap/ic_launcher");

    // iOS 세팅 - 유저 권한 요청
    const DarwinInitializationSettings initializationSettingIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingAndroid,
      iOS: initializationSettingIOS,
    );

    // 안드로이드 알람 권한 요청
    if (Platform.isAndroid) {
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    }

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      //푸시 알람 탭 클릭시 호출 콜백함수
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    // 로그인 상태 체크 후 알림 보내기
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        sendNotifications(user.uid); // 로그인한 순간 알림 전송
      }
    });
  }

  // 일반 푸시알람 보내기
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    // 현재 사용자 uid
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    // 저장할 날짜 포맷팅(yy-mm-dd)
    DateTime now = DateTime.now();
    String formattedDate = '${now.year.toString().substring(2, 4)}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    // 알림 보낼 시간 설정 (오전 8시)
    final scheduledTime = tz.TZDateTime.from(
      DateTime.now().copyWith(hour: 8, minute: 0, second: 0),
      tz.local,
    );

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel 1', 'channel 1 name',
        channelDescription: 'channel 1 desc',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        scheduledTime,
        notificationDetails,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    // 알림 데이터를 SharedPreferences에 저장 by uID
    final prefs = await SharedPreferences.getInstance();
    final notificationData = '$formattedDate|$title|$body|$payload|unread';
    List<String>? storedNotifications = prefs.getStringList('notifications_$userId');

    storedNotifications ??= [];
    storedNotifications.add(notificationData);

    prefs.setStringList('notifications_$userId', storedNotifications);
  }

  // 물 줄 시간이 된 식물들을 체크하고 푸시알림
  static Future<void> sendNotifications(String userId) async {
    try {
      final plantCollection = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("plants");

      final snapshot = await plantCollection.get();

      for (var doc in snapshot.docs) {
        var data = doc.data();
        if (data["dDayWater"] == 0) {
          await showSimpleNotification(
            title: "물 주기 알림",
            body: "오늘은 ${data["plantname"]}에게 물을 주는 날 이에요! 🌱",
            payload: doc.id,
          );
        }
      }
    } catch (e) {
      print("알림 전송 중 오류 발생: $e");
    }
  }

  // SharedPreferences 비우기
  static void clearAllSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();  // SharedPreferences의 모든 데이터를 삭제
  }

}