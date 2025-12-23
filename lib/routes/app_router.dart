import 'package:Travelon/AppStartupPage.dart';
import 'package:Travelon/features/auth/presentation/pages/LoginPage.dart';
import 'package:Travelon/features/auth/presentation/pages/RegisterationPage.dart';
import 'package:Travelon/features/home/presentation/pages/homepage.dart';
import 'package:Travelon/features/map/presentation/pages/homePage.dart';
import 'package:Travelon/features/splash/pages/landingpage.dart';
import 'package:Travelon/features/splash/pages/onboardingpage.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AppStartupPage()),
    GoRoute(path: '/onboarding', builder: (context, state) => Onboardingpage()),
    GoRoute(
      path: '/landingpage',
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: '/register',

      // builder: (context, state) => const RegisterPage(),
      builder: (context, state) => const RegistrationPage(),
    ),
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(path: '/home', builder: (context, state) => Homepage()), //old home
    // GoRoute(path: '/home', builder: (context, state) => HomePage()),
  ],
);
