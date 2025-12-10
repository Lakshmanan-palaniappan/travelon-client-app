import 'package:Travelon/app.dart';
import 'package:Travelon/core/network/apiclient.dart';
import 'package:Travelon/features/auth/data/datasources/tourist_remote_datasource.dart';
import 'package:Travelon/features/auth/data/repositories/tourist_repository_impl.dart';
import 'package:Travelon/features/auth/domain/usecases/get_tourist_details.dart';
import 'package:Travelon/features/auth/domain/usecases/login_tourist.dart';
import 'package:Travelon/features/auth/domain/usecases/register_tourist.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Travelon/features/map/data/repository/location_repository_impl.dart';
import 'package:Travelon/features/map/presentation/bloc/location_bloc.dart';
import 'package:Travelon/features/trip/data/datasources/trip_remote_datasource.dart';
import 'package:Travelon/features/trip/data/repositories/trip_repository_impl.dart';
import 'package:Travelon/features/trip/domain/usecases/get_places_usecase.dart';
import 'package:Travelon/features/trip/presentation/bloc/trip_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");

  // ✅ Initialize dependencies (Clean Architecture layers)
  final apiClient = ApiClient();
  final remoteDataSource = TouristRemoteDataSourceImpl(apiClient);
  final repository = TouristRepositoryImpl(remoteDataSource);

  final registerUseCase = RegisterTourist(repository);
  final loginUseCase = LoginTourist(repository);
  final getTouristDetailsUseCase = GetTouristDetails(repository);

  // ✅ Initialize AuthBloc before runApp
  final authBloc = AuthBloc(
    registerTourist: registerUseCase,
    loginTourist: loginUseCase,
    getTouristDetails: getTouristDetailsUseCase,
  );

  // ✅ Load stored authentication after dependencies are ready
  authBloc.add(LoadAuthFromStorage());

  final agencyDataSource = TripRemoteDataSource(apiClient);
  final tripRepository = TripRepositoryImpl(agencyDataSource, apiClient);
  final getAgencyPlacesUsecase = GetAgencyPlaces(tripRepository);

  final tripBloc = TripBloc(
    getAgencyPlaces: getAgencyPlacesUsecase,
    tripRepository: tripRepository,
  );

  final locrepo = LocationRepositoryImpl("http://103.207.1.87:5821/api/trilateration/get-location");
  final locBloc = LocationBloc(locrepo);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: authBloc),
        BlocProvider<TripBloc>.value(value: tripBloc),
        BlocProvider<LocationBloc>.value(value: locBloc),
      ],
      child: const yenApp(), // Capitalized for convention
    ),
  );

  FlutterNativeSplash.remove();
}
