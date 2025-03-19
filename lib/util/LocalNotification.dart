import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  // 플러그인 인스턴스 생성
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // 푸시 알림 스트림 생성
  static final StreamController<String?> notificationStream =
  StreamController<String?>.broadcast();

  // 푸시 알림 탭 했을 때 호출되는 함수
  static void onNotificationTap(NotificationResponse notificationResponse) {
    notificationStream.add(notificationResponse.payload!);
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

    // 로그인 상태 체크 후 알림 보내기
    await _checkLoginAndSendNotifications();
  }

  // 로그인 상태 확인 후 알림 보내기
  static Future _checkLoginAndSendNotifications() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await sendNotifications(user.uid);  // 로그인된 유저에 대해서만 알림 전송
    }
  }

  // 일반 푸시알람 보내기
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel 1', 'channel 1 name',
        channelDescription: 'channel 1 desc',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin
        .show(DateTime.now().millisecondsSinceEpoch ~/ 1000, title, body, notificationDetails, payload: payload);
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
            body: "${data["plantname"]}에게 물을 주는 날 이에요! 🌱",
            payload: doc.id,
          );
        }
      }
    } catch (e) {
      print("알림 전송 중 오류 발생: $e");
    }
  }
}