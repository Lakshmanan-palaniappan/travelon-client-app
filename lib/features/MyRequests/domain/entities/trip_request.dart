/// ---------------------------------------------------------------------------
/// TripRequest
/// ---------------------------------------------------------------------------
/// A domain entity representing a tourist's request for a planned trip.
/// 
/// This class holds the metadata for a trip in its "Request" phase, 
/// including the assigned agency/employee and the requested dates.
/// ---------------------------------------------------------------------------
class TripRequest {
  final int requestId;
  final DateTime startDate;
  final DateTime endDate;
  final String status; // e.g., 'PENDING', 'APPROVED', 'REJECTED'
  final String? agencyName;
  final String? employeeName;
  final List<RequestPlace> places;

  TripRequest({
    required this.requestId,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.agencyName,
    this.employeeName,
    required this.places,
  });
}

/// ---------------------------------------------------------------------------
/// RequestPlace
/// ---------------------------------------------------------------------------
/// A domain entity representing a specific location included in a trip request.
/// 
/// Contains geographic metadata to help the UI display the location's 
/// context (City, State, Country).
/// ---------------------------------------------------------------------------
class RequestPlace {
  final int placeId;
  final String placeName;
  final String? city;
  final String? state;
  final String? country;

  RequestPlace({
    required this.placeId,
    required this.placeName,
    this.city,
    this.state,
    this.country,
  });
}