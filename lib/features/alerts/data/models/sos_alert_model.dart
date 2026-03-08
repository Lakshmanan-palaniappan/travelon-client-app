/// ---------------------------------------------------------------------------
/// SosAlertModel
/// ---------------------------------------------------------------------------
/// The Data layer representation of an Emergency SOS signal.
/// 
/// This class handles the mapping between raw API responses and the 
/// application's internal SOS state, including high-precision 
/// coordinate parsing for location accuracy.
/// ---------------------------------------------------------------------------
class SosAlertModel {
  final String sosId;
  final int touristId;
  final double latitude;
  final double longitude;
  final int accuracy; // Horizontal accuracy in meters
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

  /// -------------------------------------------------------------------------
  /// Deserialization: JSON -> Model
  /// 
  /// Logic:
  /// - [sosId]: Forced string conversion to ensure consistency.
  /// - [latitude/longitude]: Cast via 'as num' to safely handle both int and double.
  /// - [createdAt]: Converts ISO-8601 server strings into local [DateTime] objects.
  /// -------------------------------------------------------------------------
  factory SosAlertModel.fromJson(Map<String, dynamic> json) {
    return SosAlertModel(
      sosId: json['SOSId'].toString(),
      touristId: json['TouristId'],
      // Using 'as num' is a best practice to avoid type exceptions if the 
      // backend sends a whole number (int) instead of a decimal (double).
      latitude: (json['Latitude'] as num).toDouble(),
      longitude: (json['Longitude'] as num).toDouble(),
      accuracy: (json['Accuracy'] as num).toInt(),
      message: json['Message'] ?? '',
      isResolved: json['IsResolved'] == true,
      createdAt: DateTime.parse(json['CreatedAt']),
    );
  }
}