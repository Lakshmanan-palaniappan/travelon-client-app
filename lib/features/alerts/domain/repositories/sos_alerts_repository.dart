import '../entities/sos_alert.dart';

abstract class SosAlertsRepository {
  Future<List<SosAlert>> getMySosAlerts();
}
