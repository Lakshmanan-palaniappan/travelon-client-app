import 'package:Travelon/core/network/apiclient.dart';
import '../models/sos_alert_model.dart';

abstract class SosAlertsRemoteDatasource {
  Future<List<SosAlertModel>> getMySosAlerts();
}

class SosAlertsRemoteDatasourceImpl implements SosAlertsRemoteDatasource {
  final ApiClient api;

  SosAlertsRemoteDatasourceImpl(this.api);

  @override
  Future<List<SosAlertModel>> getMySosAlerts() async {
    final res = await api.get('/sos/my');

    final List list = res.data['data']['items'] as List;
    return list.map((e) => SosAlertModel.fromJson(e)).toList();
  }
}
