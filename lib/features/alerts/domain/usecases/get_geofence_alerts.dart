import '../entities/geofence_alert.dart';
import '../repositories/alerts_repository.dart';

/// ---------------------------------------------------------------------------
/// GetGeofenceAlerts
/// ---------------------------------------------------------------------------
/// A Use Case responsible for retrieving the list of geofence-triggered alerts.
/// 
/// This class acts as a single-purpose command that bridges the 
/// Presentation layer (UI/BLoC) with the Data layer (Repository) 
/// to fetch security notifications.
/// ---------------------------------------------------------------------------
class GetGeofenceAlerts {
  final AlertsRepository repository;
  
  GetGeofenceAlerts(this.repository);

  /// -------------------------------------------------------------------------
  /// Executes the retrieval request.
  /// 
  /// Returns a [Future] list of [GeofenceAlert] entities.
  /// -------------------------------------------------------------------------
  Future<List<GeofenceAlert>> call() {
    // Delegates the data fetch to the repository contract
    return repository.getGeofenceAlerts();
  }
}