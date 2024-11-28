import 'package:go_router/go_router.dart';

// Screens
import '../screens/auth/login_start_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';

class AuthRoutes {
  static List<GoRoute> getRoutes() => [
    GoRoute(
      path: '/start',
      builder: (context, state) => LoginStartScreen(),
      routes: [
        GoRoute(
          path: 'login', // /start/login
          builder: (context, state) => LoginScreen(),
        ),
        GoRoute(
          path: 'signup', // /start/signup
          builder: (context, state) => SignupScreen(),
        ),
      ],
    ),
  ];
}
