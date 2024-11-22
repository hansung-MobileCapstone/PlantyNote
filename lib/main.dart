import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/login_start_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/onboarding/plant_onboarding_screen.dart';
import 'screens/main/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
