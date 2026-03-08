import '../../domain/entities/geofence_alert.dart';

/// ---------------------------------------------------------------------------
/// GeofenceAlertModel
/// ---------------------------------------------------------------------------
/// The Data layer representation of a Geofence Alert.
/// 
/// This class extends the [GeofenceAlert] entity to add serialization 
/// logic (JSON parsing) while maintaining compatibility with the Domain layer.
/// ---------------------------------------------------------------------------
class GeofenceAlertModel extends GeofenceAlert {
  GeofenceAlertModel({
    required super.alertId,
    required super.touristId,
    super.placeId,
    super.placeName,
    super.distanceMeters,
    required super.alertType,
    required super.severity,
    required super.message,
    required super.isResolved,
    required super.createdAt,
  });

  /// -------------------------------------------------------------------------
  /// Deserialization: JSON -> Model
  /// Maps raw API fields to typed Dart properties.
  /// 
  /// Key Transformations:
  /// - [isResolved]: Handles both Boolean and Integer (1/0) representations.
  /// - [createdAt]: Converts ISO-8601 strings into [DateTime] objects.
  /// -------------------------------------------------------------------------
  factory GeofenceAlertModel.fromJson(Map<String, dynamic> json) {
    return GeofenceAlertModel(
      alertId: json['AlertId'],
      touristId: json['TouristId'],
      placeId: json['PlaceId'],
      placeName: json['PlaceName'],
      distanceMeters: json['DistanceMeters'],
      alertType: json['AlertType'],
      severity: json['Severity'],
      message: json['Message'],
      // Defensive parsing for the boolean flag
      isResolved: json['IsResolved'] == true || json['IsResolved'] == 1,
      // Date parsing ensures time-based sorting is possible in the UI
      createdAt: DateTime.parse(json['CreatedAt']),
    );
  }
}