import 'package:Travelon/features/auth/presentation/pages/registration.dart';
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
      routerConfig: appRouter,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Archivo',
      ),
    );
  }
}
