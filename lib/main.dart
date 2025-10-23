import 'package:Travelon/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// app entry point
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(yenApp());
  // final appRouter = await createRouter();
  //
  // runApp(yenApp(appRouter: appRouter));
  FlutterNativeSplash.remove();
}
