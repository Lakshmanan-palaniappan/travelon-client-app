import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'core/di/injection_container.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");

  InjectionContainer.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: InjectionContainer.authBloc),
        BlocProvider.value(value: InjectionContainer.tripBloc),
        BlocProvider.value(value: InjectionContainer.locationBloc),
      ],
      child: const yenApp(),
    ),
  );

  FlutterNativeSplash.remove();
}
