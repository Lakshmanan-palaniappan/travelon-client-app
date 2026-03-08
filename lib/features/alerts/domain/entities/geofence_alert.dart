/// ---------------------------------------------------------------------------
/// GeofenceAlert
/// ---------------------------------------------------------------------------
/// A Domain Entity representing a location-based security notification.
/// 
/// This class holds the essential data for an alert triggered when a 
/// tourist enters or exits a predefined safety boundary.
/// ---------------------------------------------------------------------------
class GeofenceAlert {
  final int alertId;
  final int touristId;
  final int? placeId;
  final String? placeName;
  final int? distanceMeters;
  final String alertType; // e.g., 'ENTER', 'EXIT'
  final String severity;  // e.g., 'WARNING', 'DANGER', 'INFO'
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