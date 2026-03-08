/// ---------------------------------------------------------------------------
/// SosAlert
/// ---------------------------------------------------------------------------
/// A Domain Entity representing an active or past emergency SOS signal.
/// 
/// This class defines the core data structure for life-safety events,
/// providing GPS coordinates and resolution timestamps without any 
/// Data-layer dependencies (like JSON parsing).
/// ---------------------------------------------------------------------------
class SosAlert {
  final int sosId;
  final double lat;
  final double lng;
  final double? accuracy;
  final String message;
  final bool isResolved;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  SosAlert({
    required this.sosId,
    required this.lat,
    required this.lng,
    this.accuracy,
    required this.message,
    required this.isResolved,
    required this.createdAt,
    this.resolvedAt,
  });
}