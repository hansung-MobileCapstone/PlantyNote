import 'package:flutter/material.dart';
// import 'screens/community/post_create_screen.dart';
import 'screens/plants/my_plant_collection_screen.dart';
import 'screens/plants/my_plant_register_screen.dart';
import 'screens/plants/my_plant_timeline_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantyNote',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/plant_collection',
      routes: {
        '/plant_collection': (context) => const MyPlantCollectionScreen(),
        '/plant_register': (context) => const MyPlantRegisterScreen(),
        '/plant_timeline': (context) => const MyPlantTimelineScreen(),
      },
    );
  }
}
