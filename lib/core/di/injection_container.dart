import 'package:Travelon/features/auth/domain/usecases/change_password.dart';
import 'package:Travelon/features/auth/domain/usecases/forgot_password.dart';
import 'package:Travelon/features/auth/domain/usecases/updatetourist.dart';
import 'package:Travelon/features/map/data/datasource/location_sync_service.dart';
import 'package:Travelon/features/map/presentation/cubit/wifi_cubit.dart';
import 'package:Travelon/features/sos/data/sos_api.dart';
import 'package:Travelon/features/sos/presentation/cubit/sos_cubit.dart';
import 'package:Travelon/features/trip/domain/usecases/get_assigned_employee.dart';
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
  static late LocationSyncService locationSyncService;

  static late TripRepositoryImpl tripRepo;
  static late WifiCubit wifiCubit;
  static late SosCubit sosCubit;

  static void init() {
    wifiCubit = WifiCubit();

    // CORE
    apiClient = ApiClient();

    // LOCATION SYNC
    // locationSyncService = LocationSyncService(apiClient);

    // ================= AUTH =================
    final authRemote = TouristRemoteDataSourceImpl(apiClient);
    final authRepo = TouristRepositoryImpl(authRemote);
    // ================= SOS =================
    final sosApi = SosApi(apiClient);
    sosCubit = SosCubit(sosApi);
    authBloc = AuthBloc(
      updateTourist: UpdateTourist(authRepo),
      registerTourist: RegisterTourist(authRepo),
      loginTourist: LoginTourist(authRepo),
      getTouristDetails: GetTouristDetails(authRepo),
      forgotPassword: ForgotPassword(authRepo),
      changePassword: ChangePassword(authRepo),
    )..add(LoadAuthFromStorage());

    // ================= TRIP =================
    final tripRemote = TripRemoteDataSource(apiClient);
    final tripRepo = TripRepositoryImpl(tripRemote, apiClient);

    tripBloc = TripBloc(
      getAgencyPlaces: GetAgencyPlaces(tripRepo),
      tripRepository: tripRepo,
      getAssignedEmployee: GetAssignedEmployee(tripRepo),
    );
    locationSyncService = LocationSyncService(apiClient);
    // ================= LOCATION =================
    final locationRemote = LocationRemoteDataSourceImpl(apiClient);
    final locationRepo = LocationRepositoryImpl(locationRemote);

    locationBloc = LocationBloc(locationRepo);
  }
}
