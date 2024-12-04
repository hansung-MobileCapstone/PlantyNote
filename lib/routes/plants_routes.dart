import 'package:go_router/go_router.dart';

// Screens
import '../screens/plants/my_plant_collection_screen.dart';
import '../screens/plants/my_plant_register_screen.dart';
import '../screens/plants/my_plant_timeline_screen.dart';

class PlantsRoutes {
  static List<GoRoute> getRoutes() => [
    GoRoute(
      path: '/plants',
      builder: (context, state) => MyPlantCollectionScreen(),
      routes: [
        GoRoute(
          path: 'register', // /plants/register
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return MyPlantRegisterScreen(
              isEditing: extra['isEditing'] ?? false,
              plantId: extra['plantId'] as String?,
              plantData: extra['plantData'] as Map<String, dynamic>?,
            );
          },
        ),
        GoRoute(
          path: 'timeline/:plantId', // /plants/timeline/식물고유ID
          builder: (context, state) {
            final plantId = state.pathParameters['plantId']!;
            return MyPlantTimelineScreen(plantId: plantId);
          },
        ),
      ],
    ),
  ];
}
