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
    ),
    GoRoute(
      path: '/community/create',
      builder: (context, state) => PostCreateScreen(),
    ),
    GoRoute( // 되돌아가기 위해 하위 경로가 아닌 독립적인 경로로 설정
      path: '/community/detail',
      builder: (context, state) => PostDetailScreen(),
    ),
  ];
}
