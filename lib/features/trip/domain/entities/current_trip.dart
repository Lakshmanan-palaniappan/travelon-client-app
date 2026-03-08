/// ---------------------------------------------------------------------------
/// CurrentTrip
/// ---------------------------------------------------------------------------
/// A domain entity and data model representing the user's active trip state.
/// 
/// This class is used to track the status of the trip the tourist is 
/// currently participating in.
/// ---------------------------------------------------------------------------
class CurrentTrip {
  final int tripId;
  final int touristId;
  final String status;

  CurrentTrip({
    required this.tripId,
    required this.touristId,
    required this.status,
  });

  /// -------------------------------------------------------------------------
  /// Getter: isOngoing
  /// -------------------------------------------------------------------------
  /// Returns [true] if the trip status is 'ONGOING'.
  /// 
  /// Used by the UI to decide whether to show active tracking features 
  /// or navigation buttons.
  bool get isOngoing => status.toUpperCase() == 'ONGOING';

  /// -------------------------------------------------------------------------
  /// Factory: fromJson
  /// -------------------------------------------------------------------------
  /// Creates a [CurrentTrip] instance from a backend JSON [Map].
  /// 
  /// Expected JSON keys:
  /// - 'TripId'
  /// - 'TouristId'
  /// - 'Status'
  factory CurrentTrip.fromJson(Map<String, dynamic> json) {
    return CurrentTrip(
      tripId: json['TripId'],
      touristId: json['TouristId'],
      status: json['Status'],
    );
  }
}