class GeofenceAlert {
  final int alertId;
  final int touristId;
  final int? placeId;
  final String? placeName;
  final int? distanceMeters;
  final String alertType;
  final String severity;
  final String message;
  final bool isResolved;
  final DateTime createdAt;

  GeofenceAlert({
    required this.alertId,
    required this.touristId,
    this.placeId,
    this.placeName,
    this.distanceMeters,
    required this.alertType,
    required this.severity,
    required this.message,
    required this.isResolved,
    required this.createdAt,
  });
}
