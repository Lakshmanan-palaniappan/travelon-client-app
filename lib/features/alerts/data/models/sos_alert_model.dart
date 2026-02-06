class SosAlertModel {
  final String sosId;
  final int touristId;
  final double latitude;
  final double longitude;
  final int accuracy;
  final String message;
  final bool isResolved;
  final DateTime createdAt;

  SosAlertModel({
    required this.sosId,
    required this.touristId,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.message,
    required this.isResolved,
    required this.createdAt,
  });

  factory SosAlertModel.fromJson(Map<String, dynamic> json) {
    return SosAlertModel(
      sosId: json['SOSId'].toString(),
      touristId: json['TouristId'],
      latitude: (json['Latitude'] as num).toDouble(),
      longitude: (json['Longitude'] as num).toDouble(),
      accuracy: (json['Accuracy'] as num).toInt(),
      message: json['Message'] ?? '',
      isResolved: json['IsResolved'] == true,
      createdAt: DateTime.parse(json['CreatedAt']),
    );
  }
}
