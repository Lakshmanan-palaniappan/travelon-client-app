import '../../data/models/sos_alert_model.dart';
import '../../data/repositories/sos_alerts_repository_impl.dart';

class GetSosAlerts {
  final SosAlertsRepositoryImpl repo;

  GetSosAlerts(this.repo);

  Future<List<SosAlertModel>> call() {
    return repo.getMySosAlerts();
  }
}
