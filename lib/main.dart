import 'dart:async';
import 'package:Travelon/core/utils/theme/cubit/theme_cubit.dart';
import 'package:Travelon/features/map/presentation/cubit/gps_cubit.dart';
import 'package:Travelon/features/map/presentation/cubit/wifi_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'core/di/injection_container.dart';
import 'core/widgets/global_alert_host.dart';

void main() async {
  /// Runs the app inside a guarded zone to capture uncaught asynchronous errors
  runZonedGuarded(
    () async {
      final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

      /// Keeps the native splash screen visible until initialization completes

      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

      /// Loads environment variables from the .env file
      await dotenv.load(fileName: ".env");

      /// Initializes dependency injection container and registers app services
      InjectionContainer.init();

      /// Handles Flutter framework errors to prevent app crashes
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
      };

      /// Provides global blocs and cubits for the application

      runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => GpsCubit()),
            BlocProvider(create: (_) => WifiCubit()),
            BlocProvider(create: (_) => ThemeCubit()),
            BlocProvider.value(value: InjectionContainer.authBloc),
            BlocProvider.value(value: InjectionContainer.tripBloc),
            BlocProvider.value(value: InjectionContainer.locationBloc),
            BlocProvider.value(value: InjectionContainer.myRequestsBloc),
            BlocProvider.value(value: InjectionContainer.geofenceAlertBloc),
            BlocProvider.value(value: InjectionContainer.sosAlertBloc),
            BlocProvider.value(value: InjectionContainer.sosCubit),
            BlocProvider.value(value: InjectionContainer.agencyBloc),
          ],

          /// Hosts global alert widgets that can be triggered from anywhere in the app
          child: GlobalAlertHost(child: const YenApp()),
        ),
      );

      /// Removes the native splash screen after app initialization

      FlutterNativeSplash.remove();
    },
    (error, stack) {
      /// Handles uncaught asynchronous errors
    },
  );
}
