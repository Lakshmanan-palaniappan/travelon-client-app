import 'package:flutter/material.dart';

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
      ),
      // home: WifiLocator(),
      home: MapPage(),
    );
  }
}
