import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_geofence_alerts.dart';
import '../../domain/usecases/resolve_geofence_alert.dart';
import 'geofence_alert_event.dart';
import 'geofence_alert_state.dart';

class GeofenceAlertBloc extends Bloc<GeofenceAlertEvent, GeofenceAlertState> {
  final GetGeofenceAlerts getGeofenceAlerts;
  final ResolveGeofenceAlert resolveGeofenceAlert;

  GeofenceAlertBloc({
    required this.getGeofenceAlerts,
    required this.resolveGeofenceAlert,
  }) : super(GeofenceAlertInitial()) {
    print("🚨 GeofenceAlertBloc CREATED");
    on<LoadGeofenceAlerts>(_onLoad);
    on<ResolveGeofenceAlertEvent>(_onResolve);
    on<ChangeGeofenceFilter>(_onFilter);
  }

  Future<void> _onLoad(
      LoadGeofenceAlerts event, Emitter<GeofenceAlertState> emit) async {
    print("📥 LoadGeofenceAlerts EVENT FIRED");
    emit(GeofenceAlertLoading());
    try {
      final alerts = await getGeofenceAlerts();
      print("✅ Alerts loaded: ${alerts.length}");
      emit(GeofenceAlertLoaded(allAlerts: alerts, filter: GeofenceFilter.all));
    } catch (e) {
      print("❌ Error loading alerts: $e");
      emit(GeofenceAlertError("Failed to load alerts"));
    }
  }

  Future<void> _onResolve(
      ResolveGeofenceAlertEvent event, Emitter<GeofenceAlertState> emit) async {
    try {
      await resolveGeofenceAlert(event.alertId);
      final alerts = await getGeofenceAlerts();
      emit(GeofenceAlertLoaded(allAlerts: alerts, filter: GeofenceFilter.all));
    } catch (_) {
      emit(GeofenceAlertError("Failed to resolve alert"));
    }
  }

  void _onFilter(
      ChangeGeofenceFilter event, Emitter<GeofenceAlertState> emit) {
    if (state is GeofenceAlertLoaded) {
      final s = state as GeofenceAlertLoaded;
      emit(GeofenceAlertLoaded(allAlerts: s.allAlerts, filter: event.filter));
    }
  }
}
