class CurrentTrip {
  final int tripId;
  final int touristId;
  final String status;

  CurrentTrip({
    required this.tripId,
    required this.touristId,
    required this.status,
  });

  bool get isOngoing => status.toUpperCase() == 'ONGOING';

  factory CurrentTrip.fromJson(Map<String, dynamic> json) {
    return CurrentTrip(
      tripId: json['TripId'],
      touristId: json['TouristId'],
      status: json['Status'],
      // status: "ONGOING",
    );
  }
}
