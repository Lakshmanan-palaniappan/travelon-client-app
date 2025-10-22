import 'package:flutter/material.dart';

import 'features/splash/pages/onboardingpage.dart';
import 'mypage.dart';

// main function
class yenApp extends StatelessWidget {
  const yenApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Archivo',
      ),
      // home: WifiLocator(),
      // home: MapPage(),
      home: Onboardingpage(),
    );
  }
}
