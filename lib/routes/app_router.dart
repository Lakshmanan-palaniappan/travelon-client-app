import 'package:Travelon/core/utils/widgets/MyLoader.dart';
import 'package:Travelon/features/auth/presentation/pages/LoginPage.dart';
import 'package:Travelon/features/auth/presentation/pages/RegisterPage.dart';
import 'package:Travelon/features/splash/pages/landingpage.dart';
import 'package:Travelon/features/splash/pages/onboardingpage.dart';
import 'package:Travelon/mypage.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // GoRoute(path: '/', builder: (context, state) => Myloader()),
    GoRoute(path: '/', builder: (context, state) => Onboardingpage()),
    GoRoute(
      path: '/landingpage',
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: '/register',
      // builder: (context, state) => const RegisterTouristPage(),
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(path: '/home', builder: (context, state) => MapPage()),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
  ],
);
