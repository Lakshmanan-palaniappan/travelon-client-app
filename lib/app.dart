import 'package:Travelon/core/utils/appcolors.dart';
import 'package:Travelon/routes/app_router.dart';
import 'package:flutter/material.dart';

// main function
class yenApp extends StatelessWidget {
  const yenApp({super.key});
  // final GoRouter appRouter;
  // const yenApp({super.key, required this.appRouter});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppThemes.lightTheme,
      routerConfig: appRouter,
      title: 'Travelon',
      debugShowCheckedModeBanner: false,
    );
  }
}
