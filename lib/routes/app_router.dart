import 'package:Travelon/features/auth/presentation/pages/login.dart';
import 'package:Travelon/features/splash/pages/landingpage.dart';
import 'package:Travelon/features/splash/pages/onboardingpage.dart';
import 'package:Travelon/mypage.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/pages/registration.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => Onboardingpage()),
    GoRoute(
      path: '/landingpage',
      builder: (context, state) => const Landingpage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterTouristPage(),
    ),
    GoRoute(path: '/home', builder: (context, state) => MapPage()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
  ],
);
