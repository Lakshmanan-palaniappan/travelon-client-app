import '../datasources/sos_alerts_remote_datasource.dart';
import '../models/sos_alert_model.dart';

/// ---------------------------------------------------------------------------
/// SosAlertsRepositoryImpl
/// ---------------------------------------------------------------------------
/// A concrete repository implementation for managing SOS alert data.
/// 
/// Responsibility:
/// - Acts as the single point of entry for retrieving SOS history.
/// - Coordinates with the [SosAlertsRemoteDatasource] to fetch data 
///   from the network.
/// ---------------------------------------------------------------------------
class SosAlertsRepositoryImpl {
  final SosAlertsRemoteDatasource remote;

  SosAlertsRepositoryImpl(this.remote);

  /// -------------------------------------------------------------------------
  /// getMySosAlerts
  /// -------------------------------------------------------------------------
  /// Retrieves a chronological list of SOS alerts triggered by the current user.
  /// 
  /// Returns a [Future] list of [SosAlertModel] objects containing GPS 
  /// coordinates and timestamps of past emergencies.
  /// -------------------------------------------------------------------------
  Future<List<SosAlertModel>> getMySosAlerts() {
    // Delegates the data retrieval to the remote data source
    return remote.getMySosAlerts();
  }
}