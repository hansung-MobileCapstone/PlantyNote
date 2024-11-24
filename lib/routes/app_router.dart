import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Importing all routes
import './auth_routes.dart';
import './main_routes.dart';
import './plants_routes.dart';
import './community_routes.dart';
import './profile_routes.dart';
import './onboarding_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/onboarding', // 앱 실행 시 처음 표시될 경로
    routes: [
      ...OnboardingRoutes.getRoutes(),
      ...AuthRoutes.getRoutes(),
      ...MainRoutes.getRoutes(),
      ...PlantsRoutes.getRoutes(),
      ...CommunityRoutes.getRoutes(),
      ...ProfileRoutes.getRoutes(),
    ],
  );
}
