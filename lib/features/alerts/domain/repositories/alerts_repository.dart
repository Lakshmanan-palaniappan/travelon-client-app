import '../entities/geofence_alert.dart';

abstract class AlertsRepository {
  Future<List<GeofenceAlert>> getGeofenceAlerts();
  Future<void> resolveGeofenceAlert(int alertId);
}
