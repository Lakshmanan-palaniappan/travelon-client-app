import '../repositories/alerts_repository.dart';

class ResolveGeofenceAlert {
  final AlertsRepository repository;
  ResolveGeofenceAlert(this.repository);

  Future<void> call(int alertId) {
    return repository.resolveGeofenceAlert(alertId);
  }
}
