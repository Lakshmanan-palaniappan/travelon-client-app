import 'package:Travelon/core/network/apiclient.dart';
import '../models/sos_alert_model.dart';

/// ---------------------------------------------------------------------------
/// SosAlertsRemoteDatasource
/// ---------------------------------------------------------------------------
/// Abstract contract for SOS-related network operations.
/// 
/// Defines the behavior for retrieving a specific user's SOS alert history
/// from the remote server.
/// ---------------------------------------------------------------------------
abstract class SosAlertsRemoteDatasource {
  Future<List<SosAlertModel>> getMySosAlerts();
}

/// ---------------------------------------------------------------------------
/// SosAlertsRemoteDatasourceImpl
/// ---------------------------------------------------------------------------
/// Concrete implementation of [SosAlertsRemoteDatasource] using [ApiClient].
/// ---------------------------------------------------------------------------
class SosAlertsRemoteDatasourceImpl implements SosAlertsRemoteDatasource {
  final ApiClient api;

  SosAlertsRemoteDatasourceImpl(this.api);

  /// -------------------------------------------------------------------------
  /// getMySosAlerts
  /// -------------------------------------------------------------------------
  /// Fetches a list of SOS alerts triggered by the current authenticated user.
  /// 
  /// Logic:
  /// - Performs a GET request to the `/sos/my` endpoint.
  /// - Navigates through a nested JSON structure (data -> items).
  /// - Maps the raw dynamic list into a typed [SosAlertModel] list.
  /// -------------------------------------------------------------------------
  @override
  Future<List<SosAlertModel>> getMySosAlerts() async {
    final res = await api.get('/sos/my');

    // Deep-key extraction from the API response envelope
    final List list = res.data['data']['items'] as List;
    
    return list.map((e) => SosAlertModel.fromJson(e)).toList();
  }
}