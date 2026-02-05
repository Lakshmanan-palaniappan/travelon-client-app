import 'package:Travelon/core/network/apiclient.dart';

class ApiException implements Exception {
  final int statusCode;
  final dynamic data;

  ApiException(this.statusCode, this.data);
}

class SosApi {
  final ApiClient apiClient;

  SosApi(this.apiClient);

  Future<void> triggerSOS({
    required List<Map<String, dynamic>> wifiAccessPoints,
    required Map<String, dynamic>? gps,
    String? message,
  }) async {
    final payload = {
      if (wifiAccessPoints.isNotEmpty) "wifiAccessPoints": wifiAccessPoints,
      if (gps != null) "gps": gps,
      if (message != null) "message": message,
    };

    final response = await apiClient.post("/sos/trigger", payload);

    // If your ApiClient returns something like { statusCode, data }
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ApiException(response.statusCode!, response.data);
    }
  }

}
