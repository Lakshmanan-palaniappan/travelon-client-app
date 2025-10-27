import 'package:Travelon/app.dart';
import 'package:Travelon/features/auth/data/datasources/tourist_remote_datasource.dart';
import 'package:Travelon/features/auth/data/repositories/tourist_repository_impl.dart';
import 'package:Travelon/features/auth/domain/usecases/register_tourist.dart';
import 'package:Travelon/features/auth/presentation/bloc/tourist_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// app entry point
void main() async {
 final remoteDataSource = TouristRemoteDataSourceImpl();
  final repository = TouristRepositoryImpl(remoteDataSource);
  final usecase = RegisterTourist(repository);
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(    BlocProvider(
      create: (_) => TouristBloc(usecase),
      child: const yenApp(),
    ),);
  // final appRouter = await createRouter();
  //
  // runApp(yenApp(appRouter: appRouter));
  FlutterNativeSplash.remove();
}




