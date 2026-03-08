import 'package:Travelon/core/network/apiclient.dart';

/// ---------------------------------------------------------------------------
/// ApiException
/// ---------------------------------------------------------------------------
/// Custom exception for SOS-related API failures.
/// 
/// Captures the [statusCode] and raw [data] from the backend to allow
/// the presentation layer to show specific error messages based on the failure.
/// ---------------------------------------------------------------------------
class ApiException implements Exception {
  final int statusCode;
  final dynamic data;

  ApiException(this.statusCode, this.data);
}

/// ---------------------------------------------------------------------------
/// SosApi
/// ---------------------------------------------------------------------------
/// Data source for triggering emergency SOS alerts.
/// 
/// Communicates with the `/sos/trigger` endpoint to send location data 
/// and emergency messages to the backend server.
/// ---------------------------------------------------------------------------
class SosApi {
  final ApiClient apiClient;

  SosApi(this.apiClient);

  /// -------------------------------------------------------------------------
  /// triggerSOS
  /// -------------------------------------------------------------------------
  /// Sends an emergency alert with available location telemetry.
  /// 
  /// Parameters:
  /// - [wifiAccessPoints]: List of nearby Wi-Fi networks for urban/indoor positioning.
  /// - [gps]: Precise latitude/longitude coordinates if available.
  /// - [message]: Optional user-defined emergency note.
  /// 
  /// Logic:
  /// - Constructs a dynamic payload containing only non-null/non-empty fields.
  /// - Throws [ApiException] if the server returns a non-success status code.
  /// -------------------------------------------------------------------------
  Future<void> triggerSOS({
    required List<Map<String, dynamic>> wifiAccessPoints,
    required Map<String, dynamic>? gps,
    String? message,
  }) async {
    // Dynamic payload construction: avoids sending null or empty keys to the backend
    final payload = {
      if (wifiAccessPoints.isNotEmpty) "wifiAccessPoints": wifiAccessPoints,
      if (gps != null) "gps": gps,
      if (message != null) "message": message,
    };

    final response = await apiClient.post("/sos/trigger", payload);

    // Strict validation: Ensures the alert was successfully acknowledged by the server
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ApiException(response.statusCode!, response.data);
    }
  }
}