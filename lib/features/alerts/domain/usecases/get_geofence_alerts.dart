import '../entities/geofence_alert.dart';
import '../repositories/alerts_repository.dart';

class GetGeofenceAlerts {
  final AlertsRepository repository;
  GetGeofenceAlerts(this.repository);

  Future<List<GeofenceAlert>> call() {
    return repository.getGeofenceAlerts();
  }
}
