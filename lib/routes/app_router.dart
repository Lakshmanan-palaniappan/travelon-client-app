import 'package:Travelon/AppStartupPage.dart';
import 'package:Travelon/features/Legal/pages/app_license.dart';
import 'package:Travelon/features/MyRequests/presentation/pages/myrequestpage.dart';
import 'package:Travelon/features/MyRequests/presentation/pages/pending_requests_page.dart';
import 'package:Travelon/features/MyRequests/presentation/pages/tripdetailspage.dart';
import 'package:Travelon/features/agency/presentation/pages/agencydetailspage.dart';
import 'package:Travelon/features/alerts/presentation/pages/alerts_page.dart';
import 'package:Travelon/features/alerts/presentation/pages/geofence_alerts_page.dart';
import 'package:Travelon/features/auth/presentation/pages/LoginPage.dart';
import 'package:Travelon/features/auth/presentation/pages/RegisterationPage.dart';
import 'package:Travelon/features/auth/presentation/pages/change_password_page.dart';
import 'package:Travelon/features/home/presentation/pages/homepage.dart';
import 'package:Travelon/features/home/presentation/pages/menupage.dart';
import 'package:Travelon/features/map/presentation/pages/homePage.dart';
import 'package:Travelon/features/mytrips/presentatoin/pages/completedtripspage.dart';
import 'package:Travelon/features/mytrips/presentatoin/pages/ongoingtripspage.dart';
import 'package:Travelon/features/mytrips/presentatoin/pages/tripspage.dart';
import 'package:Travelon/features/profile/presentation/pages/profilepage.dart';
import 'package:Travelon/features/settings/presentation/pages/settingspage.dart';
import 'package:Travelon/features/splash/pages/landingpage.dart';
import 'package:Travelon/features/splash/pages/onboardingpage.dart';

import 'package:go_router/go_router.dart';
import 'package:Travelon/core/navigation/app_navigator.dart';

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
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
    GoRoute(path: '/settings', builder: (context, state) => SettingsPage()),
    GoRoute(path: '/request', builder: (context, state) => Myrequestpage()),
    GoRoute(path: '/profile', builder: (context, state) => ProfilePage()),
    GoRoute(path: '/trips', builder: (context, state) => Tripspage()),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => ChangePasswordPage(),
    ),

    GoRoute(path: '/menu', builder: (context, state) => MenuPage()),
    GoRoute(
      path: '/requests/pending',
      builder: (_, __) => const PendingRequestsPage(),
    ),
    GoRoute(
      path: '/mytrips/ongoing',
      builder: (_, __) => const OngoingTripsPage(),
    ),
    GoRoute(
      path: '/mytrips/completed',
      builder: (_, __) => const CompletedTripsPage(),
    ),
        GoRoute(
      path: '/agency/details',
      builder: (_, __) => const AgencyDetailsPage(),
    ),
    GoRoute(
        path: '/settings/license',
    builder: ( _, __) => AppLicensePage()
    ),
    GoRoute(
        path: '/alerts',
        builder: ( _, __) => AlertsPage()
    ),
    GoRoute(
        path: '/alerts/geofence',
        builder: ( _, __) => GeofenceAlertsPage()
    ),




  ],
);
