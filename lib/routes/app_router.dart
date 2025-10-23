import 'package:Travelon/features/splash/pages/onboardingpage.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/pages/registration.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => Onboardingpage()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
  ],
);
