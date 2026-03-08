import '../repositories/alerts_repository.dart';

/// ---------------------------------------------------------------------------
/// ResolveGeofenceAlert
/// ---------------------------------------------------------------------------
/// A Use Case that handles the business logic for dismissing security alerts.
/// 
/// This class acts as a single-purpose command to mark a specific 
/// geofence alert as 'resolved' or 'acknowledged' on the backend.
/// ---------------------------------------------------------------------------
class ResolveGeofenceAlert {
  final AlertsRepository repository;
  
  ResolveGeofenceAlert(this.repository);

  /// -------------------------------------------------------------------------
  /// Executes the resolve command.
  /// 
  /// Parameters:
  /// - [alertId]: The unique identifier for the alert to be dismissed.
  /// -------------------------------------------------------------------------
  Future<void> call(int alertId) {
    // Delegates the state update to the repository contract
    return repository.resolveGeofenceAlert(alertId);
  }
}