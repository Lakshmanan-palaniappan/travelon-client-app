import '../../domain/entities/geofence_alert.dart';
import '../../domain/repositories/alerts_repository.dart';
import '../datasources/alerts_remote_datasource.dart';

/// ---------------------------------------------------------------------------
/// AlertsRepositoryImpl
/// ---------------------------------------------------------------------------
/// The concrete implementation of [AlertsRepository].
/// 
/// This class acts as a coordination layer that delegates network 
/// requests to the [AlertsRemoteDataSource]. It ensures the Domain layer 
/// receives data in the form of [GeofenceAlert] entities.
/// ---------------------------------------------------------------------------
class AlertsRepositoryImpl implements AlertsRepository {
  final AlertsRemoteDataSource remote;
  
  AlertsRepositoryImpl(this.remote);

  /// -------------------------------------------------------------------------
  /// getGeofenceAlerts
  /// -------------------------------------------------------------------------
  /// Retrieves a list of security alerts triggered by geofencing.
  /// 
  /// This method returns a [Future] list of [GeofenceAlert] entities, 
  /// abstracting away the underlying [GeofenceAlertModel] used for JSON parsing.
  /// -------------------------------------------------------------------------
  @override
  Future<List<GeofenceAlert>> getGeofenceAlerts() {
    return remote.getGeofenceAlerts();
  }

  /// -------------------------------------------------------------------------
  /// resolveGeofenceAlert
  /// -------------------------------------------------------------------------
  /// Marks a specific alert as resolved or acknowledged.
  /// 
  /// Parameters:
  /// - [alertId]: The unique identifier for the alert to be dismissed.
  /// -------------------------------------------------------------------------
  @override
  Future<void> resolveGeofenceAlert(int alertId) {
    return remote.resolveAlert(alertId);
  }
}