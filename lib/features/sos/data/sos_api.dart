import 'package:Travelon/core/network/apiclient.dart';

class SosApi {
  final ApiClient apiClient;

  SosApi(this.apiClient);

  Future<void> triggerSOS({
    required List<Map<String, dynamic>> wifiAccessPoints,
    required Map<String, dynamic>? gps,
    String? message,
  }) async {
    final payload = {
      if (wifiAccessPoints.isNotEmpty)
        "wifiAccessPoints": wifiAccessPoints,
      if (gps != null) "gps": gps,
      if (message != null) "message": message,
    };

    await apiClient.post("/sos/trigger", payload);
  }
}
