import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

// Importing all routes
import './auth_routes.dart';
import './main_routes.dart';
import './plants_routes.dart';
import './community_routes.dart';
import './profile_routes.dart';
import './onboarding_routes.dart';
import './conversation_routes.dart';
import './map_routes.dart';

class AppRouter {
  static late final GoRouter router;

  // Firebase 로그인 상태에 따라 초기 경로 설정
  static Future<void> initRouter() async {
    // Firebase의 로그인 상태 확인
    User? user = FirebaseAuth.instance.currentUser;

    router = GoRouter(
      initialLocation: user == null ? '/onboarding' : '/main',
      // 앱 실행 시 처음 표시될 경로
      routes: [
        ...OnboardingRoutes.getRoutes(),
        ...AuthRoutes.getRoutes(),
        ...MainRoutes.getRoutes(),
        ...PlantsRoutes.getRoutes(),
        ...CommunityRoutes.getRoutes(),
        ...ProfileRoutes.getRoutes(),
        ...MapRoutes.getRoutes(),
        ...ConversationRoutes.getRoutes(),
      ],
    );
  }
}
