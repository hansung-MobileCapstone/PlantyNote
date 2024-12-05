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
        GoRoute(
          path: '/community/detail',
          builder: (context, state) {
            // state.extra를 통해 docId를 전달받음
            final args = state.extra;
            String? docId;
            if (args != null && args is Map<String, dynamic>) {
              docId = args['docId'] as String?;
            }

            return PostDetailScreen(docId: docId);
          },
        ),
      ];
}
