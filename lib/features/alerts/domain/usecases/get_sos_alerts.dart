import '../../data/models/sos_alert_model.dart';
import '../../data/repositories/sos_alerts_repository_impl.dart';

/// ---------------------------------------------------------------------------
/// GetSosAlerts
/// ---------------------------------------------------------------------------
/// A Use Case responsible for retrieving a list of triggered SOS alerts.
/// 
/// This class acts as a single-purpose command that bridges the 
/// Presentation layer (UI/BLoC) with the Data layer (Repository) 
/// to fetch the historical record of emergency signals.
/// ---------------------------------------------------------------------------
class GetSosAlerts {
  final SosAlertsRepositoryImpl repo;

  GetSosAlerts(this.repo);

  /// -------------------------------------------------------------------------
  /// Executes the retrieval request.
  /// 
  /// Returns a [Future] list of [SosAlertModel] objects containing the 
  /// status, location, and timestamps of past emergencies.
  /// -------------------------------------------------------------------------
  Future<List<SosAlertModel>> call() {
    // Delegates the data fetch to the repository implementation
    return repo.getMySosAlerts();
  }
}