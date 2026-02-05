import 'package:Travelon/core/utils/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:Travelon/core/utils/appimageassets.dart';

class AppStartupPage extends StatefulWidget {
  const AppStartupPage({super.key});

  @override
  State<AppStartupPage> createState() => _AppStartupPageState();
}

class _AppStartupPageState extends State<AppStartupPage> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAppState();
    });
  }

  Future<void> _checkAppState() async {
    if (_navigated) return;

    // Force splash to stay for 5 seconds
    await Future.delayed(const Duration(seconds: 5));

    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool('onboarding_done') ?? false;
    final token = await TokenStorage.getToken();

    _navigated = true;

    if (!onboardingDone) {
      context.go('/onboarding');
    } else if (token != null) {
      context.go('/home');
    } else {
      context.go('/landingpage');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Lottie.asset(
          AppImageAssets().travelon_lottie,
          width: 220,
          height: 220,
          fit: BoxFit.contain,
          repeat: true,
        ),
      ),
    );
  }
}
