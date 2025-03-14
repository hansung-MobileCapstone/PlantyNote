import 'dart:async';
import 'dart:io';
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

  //플러그인 초기화
  static Future init() async {
    //안드로이드 알람 이미지 세팅
    const AndroidInitializationSettings initializationSettingAndroid =
    AndroidInitializationSettings("@mipmap/ic_launcher");

    //iOS 세팅 - 유저 권한 요청
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

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      //푸시 알람 탭 클릭시 호출 콜백함수
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

//일반 푸시알람 보내기
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
        .show(0, title, body, notificationDetails, payload: payload);
  }

//지정된 스케줄에 맞춰 알람 보내기
  static Future showScheduledNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    tz.initializeTimeZones(); //타임존 초기화
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        2,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel 3',
            "channel name",
            channelDescription: "channel desc",
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload);
  }
}