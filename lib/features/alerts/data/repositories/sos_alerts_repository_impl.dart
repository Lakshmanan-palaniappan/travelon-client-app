import '../datasources/sos_alerts_remote_datasource.dart';
import '../models/sos_alert_model.dart';

class SosAlertsRepositoryImpl {
  final SosAlertsRemoteDatasource remote;

  SosAlertsRepositoryImpl(this.remote);

  Future<List<SosAlertModel>> getMySosAlerts() {
    return remote.getMySosAlerts();
  }
}
