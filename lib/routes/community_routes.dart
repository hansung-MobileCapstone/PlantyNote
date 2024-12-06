import 'package:go_router/go_router.dart';
import '../screens/community/all_posts_screen.dart';
import '../screens/community/post_create_screen.dart';
import '../screens/community/post_detail_screen.dart';

class CommunityRoutes {
  static List<GoRoute> getRoutes() {
    return [
      GoRoute(
        path: '/community',
        builder: (context, state) => const AllPostsScreen(),
        routes: [
          // 게시물 생성 및 수정 라우트
          GoRoute(
            path: 'create',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final docId = extra?['docId'] as String?;
              return PostCreateScreen(docId: docId);
            },
          ),
          // 게시물 상세 보기 라우트
          GoRoute(
            path: 'detail',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final docId = extra?['docId'] as String?;
              return PostDetailScreen(docId: docId);
            },
          ),
        ],
      ),
    ];
  }
}
