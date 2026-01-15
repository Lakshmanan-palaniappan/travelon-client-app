import '../../domain/entities/trip_place.dart';

class TripPlaceModel extends TripPlace {
  TripPlaceModel({
    required super.scheduleId,
    required super.placeId,
    required super.placeName,
    required super.scheduledDate,
    required super.status,
  });

  factory TripPlaceModel.fromJson(Map<String, dynamic> json) {
    return TripPlaceModel(
      scheduleId: json['ScheduleId'],
      placeId: json['PlaceId'],
      placeName: json['PlaceName'],
      scheduledDate: DateTime.parse(json['ScheduledDate']),
      status: json['Status'],
    );
  }
}
