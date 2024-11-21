import 'package:flutter/material.dart';
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
          builder: (context, state) => MyPlantRegisterScreen(),
        ),
        GoRoute(
          path: 'timeline', // /plants/timeline
          builder: (context, state) => MyPlantTimelineScreen(),
        ),
      ],
    ),
  ];
}
