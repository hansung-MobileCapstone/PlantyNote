import 'package:go_router/go_router.dart';

// Screens
import '../screens/onboarding/plant_onboarding_screen.dart';

class OnboardingRoutes {
  static List<GoRoute> getRoutes() => [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => PlantOnboardingScreen(),
    ),
  ];
}
