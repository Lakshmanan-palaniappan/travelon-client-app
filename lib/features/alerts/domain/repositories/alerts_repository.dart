import '../entities/geofence_alert.dart';

/// ---------------------------------------------------------------------------
/// AlertsRepository
/// ---------------------------------------------------------------------------
/// Abstract contract defining the operations for managing safety alerts.
/// 
/// This interface resides in the Domain layer, ensuring that Use Cases 
/// can interact with alert data without being coupled to a specific 
/// data source (Remote API or Local Cache).
/// ---------------------------------------------------------------------------
abstract class AlertsRepository {
  
  /// -------------------------------------------------------------------------
  /// Retrieves a list of all active or historical geofence alerts.
  /// 
  /// Returns a [Future] list of [GeofenceAlert] entities.
  /// -------------------------------------------------------------------------
  Future<List<GeofenceAlert>> getGeofenceAlerts();

  /// -------------------------------------------------------------------------
  /// Marks a specific alert as resolved, effectively dismissing it 
  /// from the user's active attention.
  /// 
  /// Parameters:
  /// - [alertId]: The unique identifier for the alert.
  /// -------------------------------------------------------------------------
  Future<void> resolveGeofenceAlert(int alertId);
}