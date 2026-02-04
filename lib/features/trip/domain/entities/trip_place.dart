class TripPlace {
  final int scheduleId;
  final int placeId;
  final String placeName;
  final DateTime scheduledDate;
  final String status;
  final String? startTime;
  final String? endTime;

  TripPlace({
    required this.scheduleId,
    required this.placeId,
    required this.placeName,
    required this.scheduledDate,
    required this.status,
    this.startTime,
    this.endTime
  });
}
