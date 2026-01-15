import 'package:Travelon/features/trip/data/models/trip_place_model.dart';

import '../../domain/entities/trip_details.dart';


class TripDetailsModel extends TripDetails {
  TripDetailsModel({
    required super.id,
    required super.status,
    required super.createdAt,
          
    required super.completedAt,
    required super.places,
  });

  factory TripDetailsModel.fromJson(Map<String, dynamic> json) {
    return TripDetailsModel(
      id: json['TripId'],
      status: json['Status'],
      createdAt: DateTime.parse(json['StartDate']),
      completedAt: DateTime.parse(json['EndDate']),
      places: (json['Places'] as List)
          .map((e) => TripPlaceModel.fromJson(e))
          .toList(),
    );
  }
}
