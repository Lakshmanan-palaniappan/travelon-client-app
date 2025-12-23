import 'package:Travelon/features/auth/domain/usecases/forgot_password.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/trip/presentation/bloc/trip_bloc.dart';
import '../../features/map/presentation/bloc/location_bloc.dart';

import '../network/apiclient.dart';

// AUTH
import '../../features/auth/data/datasources/tourist_remote_datasource.dart';
import '../../features/auth/data/repositories/tourist_repository_impl.dart';
import '../../features/auth/domain/usecases/login_tourist.dart';
import '../../features/auth/domain/usecases/register_tourist.dart';
import '../../features/auth/domain/usecases/get_tourist_details.dart';

// TRIP
import '../../features/trip/data/datasources/trip_remote_datasource.dart';
import '../../features/trip/data/repositories/trip_repository_impl.dart';
import '../../features/trip/domain/usecases/get_places_usecase.dart';

// LOCATION
import '../../features/map/data/datasource/location_remote_datasource_impl.dart';
import '../../features/map/data/repository/location_repository_impl.dart';

class InjectionContainer {
  static late ApiClient apiClient;

  static late AuthBloc authBloc;
  static late TripBloc tripBloc;
  static late LocationBloc locationBloc;

  static void init() {
    // CORE
    apiClient = ApiClient();

    // ================= AUTH =================
    final authRemote = TouristRemoteDataSourceImpl(apiClient);
    final authRepo = TouristRepositoryImpl(authRemote);

    authBloc = AuthBloc(
      registerTourist: RegisterTourist(authRepo),
      loginTourist: LoginTourist(authRepo),
      getTouristDetails: GetTouristDetails(authRepo),
      forgotPassword: ForgotPassword(authRepo),
    )..add(LoadAuthFromStorage());

    // ================= TRIP =================
    final tripRemote = TripRemoteDataSource(apiClient);
    final tripRepo = TripRepositoryImpl(tripRemote, apiClient);

    tripBloc = TripBloc(
      getAgencyPlaces: GetAgencyPlaces(tripRepo),
      tripRepository: tripRepo,
    );

    // ================= LOCATION =================
    final locationRemote = LocationRemoteDataSourceImpl(apiClient);
    final locationRepo = LocationRepositoryImpl(locationRemote);

    locationBloc = LocationBloc(locationRepo);
  }
}
