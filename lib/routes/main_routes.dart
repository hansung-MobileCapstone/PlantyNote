import 'package:go_router/go_router.dart';

// Screens
import '../screens/main/main_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/notifications/push_notifications_screen.dart';

class MainRoutes {
  static List<GoRoute> getRoutes() => [
    GoRoute(
      path: '/main',
      builder: (context, state) => MainScreen(),
      routes: [
        GoRoute(
          path: 'search', // /main/search
          builder: (context, state) => SearchScreen(),
        ),
        GoRoute(
          path: 'notifications', // /main/notifications
          builder: (context, state) => NotificationScreen(),
        ),
      ],
    ),
  ];
}
