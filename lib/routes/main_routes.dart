import 'package:go_router/go_router.dart';
import '../screens/main/main_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/notifications/push_notifications_screen.dart';
import '../screens/search/search_screen_result.dart'; // 추가

class MainRoutes {
  static List<GoRoute> getRoutes() => [
    GoRoute(
      path: '/main',
      builder: (context, state) => MainScreen(),
      routes: [
        GoRoute(
          path: 'search',
          builder: (context, state) => const SearchScreen(),
          routes: [
            GoRoute(
              path: 'result',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>;
                final keyword = extra['keyword'] as String;
                return SearchScreenResult(keyword: keyword);
              },
            ),
          ],
        ),
        GoRoute(
          path: 'notifications',
          builder: (context, state) => const NotificationScreen(),
        ),
      ],
    ),
  ];
}
