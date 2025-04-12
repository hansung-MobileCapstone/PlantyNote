import 'package:go_router/go_router.dart';
import 'package:plant/screens/conversation/conversation_screen.dart';

class ConversationRoutes {
  static List<GoRoute> getRoutes() => [
        GoRoute(
          path: '/conversation',
          builder: (context, state) => const ConversationScreen(),
        ),
      ];
}
