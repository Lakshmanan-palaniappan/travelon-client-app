import 'package:Travelon/app.dart';
import 'package:Travelon/features/auth/data/datasources/tourist_remote_datasource.dart';
import 'package:Travelon/features/auth/data/repositories/tourist_repository_impl.dart';
import 'package:Travelon/features/auth/domain/usecases/login_tourist.dart';
import 'package:Travelon/features/auth/domain/usecases/register_tourist.dart';
import 'package:Travelon/features/auth/domain/usecases/get_tourist_details.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'core/network/apiclient.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");

  // Dependencies
  final apiClient = ApiClient();
  final remoteDataSource = TouristRemoteDataSourceImpl(apiClient);
  final repository = TouristRepositoryImpl(remoteDataSource);

  // Use cases
  final registerUseCase = RegisterTourist(repository);
  final loginUseCase = LoginTourist(repository);
  final getTouristDetailsUseCase = GetTouristDetails(repository);

  runApp(
    BlocProvider(
      create: (_) {
        final bloc = AuthBloc(
          registerTourist: registerUseCase,
          loginTourist: loginUseCase,
          getTouristDetails: getTouristDetailsUseCase,
        );
        // ✅ Dispatch LoadAuthFromStorage after bloc is created
        bloc.add(LoadAuthFromStorage());
        return bloc;
      },
      child: const yenApp(),
    ),
  );

  FlutterNativeSplash.remove();
}
