import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Screens
import '../screens/community/all_posts_screen.dart';
import '../screens/community/post_create_screen.dart';
import '../screens/community/post_detail_screen.dart';

class CommunityRoutes {
  static List<GoRoute> getRoutes() => [
    GoRoute(
      path: '/community',
      builder: (context, state) => AllPostsScreen(),
      routes: [
        GoRoute(
          path: 'create', // /community/create
          builder: (context, state) => PostCreateScreen(),
        ),
        GoRoute(
          path: 'detail', // /community/detail
          builder: (context, state) => PostDetailScreen(),
        ),
      ],
    ),
  ];
}
