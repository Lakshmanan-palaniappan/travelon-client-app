import 'package:Travelon/features/agency/data/datasources/agency_remote_datasource.dart';
import 'package:Travelon/features/agency/data/repositories/agency_repository_impl.dart';
import 'package:Travelon/features/agency/domain/usecases/get_agencies.dart';
import 'package:Travelon/features/agency/domain/usecases/get_agency_details.dart';
import 'package:Travelon/features/agency/presentation/bloc/agency_bloc.dart';
import 'package:Travelon/features/agency/presentation/bloc/agency_event.dart';
import 'package:Travelon/features/auth/domain/usecases/change_password.dart';
import 'package:Travelon/features/auth/domain/usecases/forgot_password.dart';
import 'package:Travelon/features/auth/domain/usecases/updatetourist.dart';
import 'package:Travelon/features/map/data/datasource/location_sync_service.dart';
import 'package:Travelon/features/map/presentation/cubit/wifi_cubit.dart';
import 'package:Travelon/features/sos/data/sos_api.dart';
import 'package:Travelon/features/sos/presentation/cubit/sos_cubit.dart';
import 'package:Travelon/features/trip/domain/usecases/get_assigned_employee.dart';
import '../../features/alerts/data/datasources/sos_alerts_remote_datasource.dart';
import '../../features/alerts/data/repositories/sos_alerts_repository_impl.dart';
import '../../features/alerts/domain/usecases/get_sos_alerts.dart';
import '../../features/alerts/presentation/bloc/sos_alert_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/trip/presentation/bloc/trip_bloc.dart';
import '../../features/map/presentation/bloc/location_bloc.dart';
import 'package:Travelon/features/MyRequests/data/datasources/my_requests_remote_datasource.dart';
import 'package:Travelon/features/MyRequests/data/repositories/my_requests_repository_impl.dart';
import 'package:Travelon/features/MyRequests/domain/usecases/get_my_requests.dart';
import 'package:Travelon/features/MyRequests/presentation/bloc/my_requests_bloc.dart';
import 'package:Travelon/features/alerts/data/datasources/alerts_remote_datasource.dart';
import 'package:Travelon/features/alerts/data/repositories/alerts_repository_impl.dart';
import 'package:Travelon/features/alerts/domain/usecases/get_geofence_alerts.dart';
import 'package:Travelon/features/alerts/domain/usecases/resolve_geofence_alert.dart';
import 'package:Travelon/features/alerts/presentation/bloc/geofence_alert_bloc.dart';


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
  static late MyRequestsBloc myRequestsBloc;
  static late GeofenceAlertBloc geofenceAlertBloc;



  static late AuthBloc authBloc;
  static late TripBloc tripBloc;
  static late LocationBloc locationBloc;
  static late LocationSyncService locationSyncService;
  static late SosAlertBloc sosAlertBloc;


  static late TripRepositoryImpl tripRepo;
  static late WifiCubit wifiCubit;
  static late SosCubit sosCubit;
  static late AgencyBloc agencyBloc;


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
    // SOS Alerts
    final sosAlertsRemote = SosAlertsRemoteDatasourceImpl(apiClient);
    final sosAlertsRepo = SosAlertsRepositoryImpl(sosAlertsRemote);
    final getSosAlerts = GetSosAlerts(sosAlertsRepo);

    sosAlertBloc = SosAlertBloc(getSosAlerts); // ✅ ASSIGN TO STATIC FIELD


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

    // ================= AGENCY =================
    final agencyRemote = AgencyRemoteDataSourceImpl(apiClient);
    final agencyRepo = AgencyRepositoryImpl(agencyRemote);

    // ================= ALERTS =================
    final alertsRemote = AlertsRemoteDataSourceImpl(apiClient);
    final alertsRepo = AlertsRepositoryImpl(alertsRemote);

    final getGeofenceAlerts = GetGeofenceAlerts(alertsRepo);
    final resolveGeofenceAlert = ResolveGeofenceAlert(alertsRepo);




    geofenceAlertBloc = GeofenceAlertBloc(
      getGeofenceAlerts: getGeofenceAlerts,
      resolveGeofenceAlert: resolveGeofenceAlert,
    );


    // ================= MY REQUESTS =================
    final myRequestsRemote = MyRequestsRemoteDataSourceImpl(apiClient);
    final myRequestsRepo = MyRequestsRepositoryImpl(myRequestsRemote);
    final getMyRequests = GetMyRequests(myRequestsRepo);


    myRequestsBloc = MyRequestsBloc(getMyRequests: getMyRequests);


    // Define both use cases
    final getAgencies = GetAgencies(agencyRepo);
    final getAgencyDetails = GetAgencyDetails(agencyRepo); // New Use Case

    // Pass both into the Bloc
    agencyBloc = AgencyBloc(
      getAgencies: getAgencies,
      getAgencyDetails: getAgencyDetails,
    )..add(LoadAgencies());


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
