class TripRequest {
  final int requestId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
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
