import '../../domain/entities/geofence_alert.dart';

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
      isResolved: json['IsResolved'] == true || json['IsResolved'] == 1,
      createdAt: DateTime.parse(json['CreatedAt']),
    );
  }
}
