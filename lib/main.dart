import 'package:Travelon/app.dart';
import 'package:Travelon/features/auth/data/datasources/tourist_remote_datasource.dart';
import 'package:Travelon/features/auth/data/repositories/tourist_repository_impl.dart';
import 'package:Travelon/features/auth/domain/usecases/login_tourist.dart';
import 'package:Travelon/features/auth/domain/usecases/register_tourist.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'core/network/apiclient.dart';

// app entry point
void main() async {
  await dotenv.load(fileName: ".env");
  final apiClient = ApiClient();
  final remoteDataSource = TouristRemoteDataSourceImpl(apiClient);
  final repository = TouristRepositoryImpl(remoteDataSource);
  final registerUseCase = RegisterTourist(repository);
  final loginUseCase = LoginTourist(repository);
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    BlocProvider(
      create:
          (_) => AuthBloc(
            registerTourist: registerUseCase,
            loginTourist: loginUseCase,
          ),
      child: const yenApp(),
    ),
  );
  // final appRouter = await createRouter();
  //
  // runApp(yenApp(appRouter: appRouter));
  FlutterNativeSplash.remove();
}
