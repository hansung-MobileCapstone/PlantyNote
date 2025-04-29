import 'package:go_router/go_router.dart';

// Screens
import '../screens/map/map_detail_screen.dart';
import '../screens/map/map_screen.dart';
import '../screens/map/map_create_screen.dart';

class MapRoutes {
  static List<GoRoute> getRoutes() => [
    GoRoute(
      path: '/map',
      builder: (context, state) => MapScreen(),
      routes: [
        GoRoute(
          path: 'create', // /map/create
          builder: (context, state) => MapCreateScreen(),
        ),
        GoRoute(
          path: 'detail', // /map/detail
          builder: (context, state) => MapDetailScreen(itemCount: 2), // 수정 예정
        ),
      ],
    ),
  ];
}
