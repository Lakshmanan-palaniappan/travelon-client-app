import 'package:flutter/cupertino.dart';

import '../../domain/entities/trip_place.dart';

class TripPlaceModel extends TripPlace {
  TripPlaceModel({
    required super.scheduleId,
    required super.placeId,
    required super.placeName,
    required super.scheduledDate,
    required super.status,
    super.startTime,
    super.endTime
  });

  factory TripPlaceModel.fromJson(Map<String, dynamic> json) {

    return TripPlaceModel(
      scheduleId: (json['ScheduleId'] as num).toInt(),
      placeId: (json['PlaceId'] as num).toInt(),
      placeName: json['PlaceName'] as String? ?? 'Unknown',
      scheduledDate: DateTime.parse(json['ScheduledDate']),
      status: json['Status'] as String? ?? 'PENDING',
      startTime: json['StartTime'] as String?,
      endTime: json['EndTime'] as String?,
    );
  }

}
