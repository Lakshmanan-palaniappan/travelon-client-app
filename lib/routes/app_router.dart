import 'package:Travelon/AppStartupPage.dart';
import 'package:Travelon/core/widgets/app_error_page.dart';
import 'package:Travelon/features/Legal/pages/app_license.dart';
import 'package:Travelon/features/MyRequests/presentation/pages/myrequestpage.dart';
import 'package:Travelon/features/MyRequests/presentation/pages/pending_requests_page.dart';
import 'package:Travelon/features/agency/presentation/pages/agencydetailspage.dart';
import 'package:Travelon/features/alerts/presentation/pages/alerts_page.dart';
import 'package:Travelon/features/alerts/presentation/pages/geofence_alerts_page.dart';
import 'package:Travelon/features/auth/presentation/pages/LoginPage.dart';
import 'package:Travelon/features/auth/presentation/pages/RegisterationPage.dart';
import 'package:Travelon/features/auth/presentation/pages/change_password_page.dart';
import 'package:Travelon/features/homeMenu/presentation/pages/menupage.dart';
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

import '../features/alerts/presentation/pages/sos_alerts_page.dart';

/// ---------------------------------------------------------------------------
/// App Router Configuration
/// ---------------------------------------------------------------------------
/// This file defines all application routes using GoRouter.
///
/// Responsibilities:
/// - Centralized navigation configuration
/// - Route-to-page mapping
/// - Global navigation handling
/// - Error page handling
///
/// Using GoRouter improves:
/// - Navigation readability
/// - Deep linking support
/// - URL-based navigation
/// ---------------------------------------------------------------------------

final appRouter = GoRouter(
  /// Global navigator key allows navigation without BuildContext
  navigatorKey: rootNavigatorKey,

  /// Handles navigation errors such as invalid routes
  errorBuilder: (context, state) {
    return AppErrorPage(
      message: state.error?.toString() ?? "Unknown error occurred",
    );
  },

  /// Initial route when the app starts
  initialLocation: '/',

  /// List of all application routes
  routes: [
    /// -----------------------------------------------------------------------
    /// Startup / Splash Flow
    /// -----------------------------------------------------------------------

    /// App startup logic (auth check, token validation etc.)
    GoRoute(path: '/', builder: (context, state) => const AppStartupPage()),

    /// Onboarding screens shown for first-time users
    GoRoute(path: '/onboarding', builder: (context, state) => Onboardingpage()),

    /// Landing page (entry screen before login/register)
    GoRoute(
      path: '/landingpage',
      builder: (context, state) => const LandingPage(),
    ),

    /// -----------------------------------------------------------------------
    /// Authentication Routes
    /// -----------------------------------------------------------------------

    /// User registration page
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegistrationPage(),
    ),

    /// Login page
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),

    /// Change password page
    GoRoute(
      path: '/change-password',
      builder: (context, state) => ChangePasswordPage(),
    ),

    /// -----------------------------------------------------------------------
    /// Main Application Pages
    /// -----------------------------------------------------------------------

    /// Main map/home screen
    GoRoute(path: '/home', builder: (context, state) => Homepage()),

    /// App settings page
    GoRoute(path: '/settings', builder: (context, state) => SettingsPage()),

    /// User profile page
    GoRoute(path: '/profile', builder: (context, state) => ProfilePage()),

    /// Menu / navigation drawer page
    GoRoute(path: '/menu', builder: (context, state) => MenuPage()),

    /// -----------------------------------------------------------------------
    /// Requests Module
    /// -----------------------------------------------------------------------

    /// All user requests
    GoRoute(path: '/request', builder: (context, state) => Myrequestpage()),

    /// Pending requests list
    GoRoute(
      path: '/requests/pending',
      builder: (_, __) => const PendingRequestsPage(),
    ),

    /// -----------------------------------------------------------------------
    /// Trips Module
    /// -----------------------------------------------------------------------

    /// All trips overview
    GoRoute(path: '/trips', builder: (context, state) => Tripspage()),

    /// Ongoing trips page
    GoRoute(
      path: '/mytrips/ongoing',
      builder: (_, __) => const OngoingTripsPage(),
    ),

    /// Completed trips page
    GoRoute(
      path: '/mytrips/completed',
      builder: (_, __) => const CompletedTripsPage(),
    ),

    /// -----------------------------------------------------------------------
    /// Agency Module
    /// -----------------------------------------------------------------------

    /// Agency details page
    GoRoute(
      path: '/agency/details',
      builder: (_, __) => const AgencyDetailsPage(),
    ),

    /// -----------------------------------------------------------------------
    /// Legal
    /// -----------------------------------------------------------------------

    /// Open source licenses page
    GoRoute(path: '/settings/license', builder: (_, __) => AppLicensePage()),

    /// -----------------------------------------------------------------------
    /// Alerts Module
    /// -----------------------------------------------------------------------

    /// Alerts overview page
    GoRoute(path: '/alerts', builder: (_, __) => AlertsPage()),

    /// Geofence alerts page
    GoRoute(path: '/alerts/geofence', builder: (_, __) => GeofenceAlertsPage()),

    /// SOS alerts page
    GoRoute(path: '/alerts/sos', builder: (_, __) => const SosAlertsPage()),

    /// -----------------------------------------------------------------------
    /// Error Handling Route
    /// -----------------------------------------------------------------------

    /// Generic error page used across the app
    /// You can navigate here with:
    /// context.go('/error', extra: "Error message");
    GoRoute(
      path: '/error',
      builder:
          (_, state) => AppErrorPage(
            message: state.extra as String? ?? "Unexpected error",
          ),
    ),
  ],
);
