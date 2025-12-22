import 'package:Travelon/core/utils/theme/AppTheme.dart';
import 'package:Travelon/routes/app_router.dart';
import 'package:flutter/material.dart';

// main function
class yenApp extends StatelessWidget {
  const yenApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
