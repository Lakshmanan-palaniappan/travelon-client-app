import 'package:Travelon/core/network/apiclient.dart';
import '../models/geofence_alert_model.dart';

/// ---------------------------------------------------------------------------
/// AlertsRemoteDataSource
/// ---------------------------------------------------------------------------
/// Abstract contract for alert-related network operations.
/// 
/// Defines the required methods for retrieving geofence-based security alerts
/// and updating their status on the server.
/// ---------------------------------------------------------------------------
abstract class AlertsRemoteDataSource {
  Future<List<GeofenceAlertModel>> getGeofenceAlerts();
  Future<void> resolveAlert(int alertId);
}

/// ---------------------------------------------------------------------------
/// AlertsRemoteDataSourceImpl
/// ---------------------------------------------------------------------------
/// Concrete implementation of [AlertsRemoteDataSource] using [ApiClient].
/// ---------------------------------------------------------------------------
class AlertsRemoteDataSourceImpl implements AlertsRemoteDataSource {
  final ApiClient apiClient;
  AlertsRemoteDataSourceImpl(this.apiClient);

  /// -------------------------------------------------------------------------
  /// getGeofenceAlerts
  /// -------------------------------------------------------------------------
  /// Fetches a list of active geofence alerts for the current tourist.
  /// 
  /// Logic:
  /// - Accesses the `/alerts/tourist` endpoint.
  /// - Checks if data is nested under a 'data' key or provided as a direct list.
  /// - Maps each JSON object into a [GeofenceAlertModel].
  /// -------------------------------------------------------------------------
  @override
  Future<List<GeofenceAlertModel>> getGeofenceAlerts() async {
    final response = await apiClient.get('/alerts/tourist');

    if (response.statusCode == 200) {
      final data = response.data;
      // Handle both direct list responses and standard 'data' envelope nesting
      final List list = data is Map && data['data'] != null ? data['data'] : data;

      return list.map((e) => GeofenceAlertModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch alerts: ${response.statusCode}");
    }
  }

  /// -------------------------------------------------------------------------
  /// resolveAlert
  /// -------------------------------------------------------------------------
  /// Updates an alert status to 'resolved' on the backend.
  /// 
  /// Parameters:
  /// - [alertId]: The unique identifier of the alert to be dismissed.
  /// -------------------------------------------------------------------------
  @override
  Future<void> resolveAlert(int alertId) async {
    final response = await apiClient.patch('/alerts/$alertId/resolve', {});
    if (response.statusCode != 200) {
      throw Exception("Failed to resolve alert");
    }
  }
}