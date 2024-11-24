import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/login_start_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/onboarding/plant_onboarding_screen.dart';
import 'screens/main/main_screen.dart';
//import 'package:plant/widgets/post/comment_modal.dart';
//import '../widgets/post/comment_item.dart';
//import '../screens/community/post_detail_screen.dart';
// import 'screens/community/post_create_screen.dart';
import 'screens/plants/my_plant_collection_screen.dart';
import 'screens/plants/my_plant_register_screen.dart';
import 'screens/plants/my_plant_timeline_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlantyNote',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const PlantOnboardingScreen(),
        '/loginStart': (context) => const LoginStartScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
      },
    );
  }
}
