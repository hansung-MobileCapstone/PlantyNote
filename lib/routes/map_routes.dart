import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
          builder: (context, state) {
            final LatLng? position = state.extra as LatLng?; // 위치 전달 받기
            return MapCreateScreen(initPosition: position);
          },
        ),
        GoRoute(
          path: 'detail', // /map/detail
          builder: (context, state) => MapDetailScreen(itemCount: 2), // 수정 예정
        ),
      ],
    ),
  ];
}
