/// ---------------------------------------------------------------------------
/// LocationResult
/// ---------------------------------------------------------------------------
/// A domain entity representing a calculated geographic position.
/// 
/// This class encapsulates the coordinates (latitude/longitude) and the 
/// confidence interval (accuracy) provided by the trilateration engine.
/// ---------------------------------------------------------------------------
class LocationResult {
  final double lat;
  final double lng;
  final double accuracy; // Accuracy radius in meters

  const LocationResult({
    required this.lat,
    required this.lng,
    required this.accuracy,
  });
}