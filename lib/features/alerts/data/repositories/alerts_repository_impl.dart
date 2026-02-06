import '../../domain/entities/geofence_alert.dart';
import '../../domain/repositories/alerts_repository.dart';
import '../datasources/alerts_remote_datasource.dart';

class AlertsRepositoryImpl implements AlertsRepository {
  final AlertsRemoteDataSource remote;
  AlertsRepositoryImpl(this.remote);

  @override
  Future<List<GeofenceAlert>> getGeofenceAlerts() {
    return remote.getGeofenceAlerts();
  }

  @override
  Future<void> resolveGeofenceAlert(int alertId) {
    return remote.resolveAlert(alertId);
  }
}
