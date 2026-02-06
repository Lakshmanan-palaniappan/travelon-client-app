import 'package:Travelon/core/network/apiclient.dart';
import '../models/geofence_alert_model.dart';

abstract class AlertsRemoteDataSource {
  Future<List<GeofenceAlertModel>> getGeofenceAlerts();
  Future<void> resolveAlert(int alertId);
}

class AlertsRemoteDataSourceImpl implements AlertsRemoteDataSource {
  final ApiClient apiClient;
  AlertsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<GeofenceAlertModel>> getGeofenceAlerts() async {
    final response = await apiClient.get('/alerts/tourist');

    print("🔔 Alerts API status: ${response.statusCode}");
    print("🔔 Alerts API raw data: ${response.data}");

    if (response.statusCode == 200) {
      final data = response.data;

      // Handle both wrapped and direct array responses
      final List list = data is Map && data['data'] != null ? data['data'] : data;

      print("🔔 Parsed alerts list length: ${list.length}");

      return list.map((e) => GeofenceAlertModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch alerts: ${response.statusCode}");
    }
  }


  @override
  Future<void> resolveAlert(int alertId) async {
    final response = await apiClient.patch('/alerts/$alertId/resolve', {});
    if (response.statusCode != 200) {
      throw Exception("Failed to resolve alert");
    }
  }
}
