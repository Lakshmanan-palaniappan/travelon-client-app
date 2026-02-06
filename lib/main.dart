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
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");

  InjectionContainer.init();

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
      child: GlobalAlertHost(child: const YenApp()),
    ),
  );

  FlutterNativeSplash.remove();
}
