import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../routes/app_router.dart';
import '../util/LocalNotification.dart';
import '../firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // .env 파일 환경변수 로드
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  await sendApiKeyToNative();
  await initService();
  runApp(const MyApp());
}

// GoogleMap API Key 전달
const platform = MethodChannel('com.example.env_channel');

Future<void> sendApiKeyToNative() async {
  final androidMapKey = dotenv.env['ANDROID_MAPS_API_KEY'];
  final iosMapKey = dotenv.env['IOS_MAPS_API_KEY'];

  await platform.invokeMethod('setApiKeys', {
    "androidMapKey": androidMapKey,
    "iosMapKey": iosMapKey,
  });
}

// 초기 구동
Future<void> initService() async {
  //* Firebase  초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 라우터 초기화
  await AppRouter.initRouter();

  // 로컬 푸시 알림 초기화
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // 로그인된 유저에 대해서만
    await LocalNotification.init();
  }

  // 앱이 종료된 상태에서 푸시 알람 탭
  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    Future.delayed(const Duration(seconds: 1), () {
      navigatorKey.currentState!.pushNamed('/message',
          arguments:
          notificationAppLaunchDetails?.notificationResponse?.payload);
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router, // GoRouter 설정 연결
    );
  }
}
