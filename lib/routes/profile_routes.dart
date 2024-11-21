import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Screens
import '../screens/profile/my_page_screen.dart';
import '../screens/profile/my_page_edit_screen.dart';

class ProfileRoutes {
  static List<GoRoute> getRoutes() => [
    GoRoute(
      path: '/profile',
      builder: (context, state) => MyPageScreen(),
      routes: [
        GoRoute(
          path: 'edit', // /profile/edit
          builder: (context, state) => MyPageEditScreen(),
        ),
      ],
    ),
  ];
}
