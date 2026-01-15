import 'package:Travelon/features/trip/data/models/trip_model.dart';

import '../../domain/entities/trip.dart';
import '../../domain/entities/trip_place.dart';
import 'trip_place_model.dart';

class TripWithPlacesModel {
  final Trip trip;
  final DateTime startDate;
  final DateTime endDate;
  final List<TripPlace> places;

  TripWithPlacesModel({
    required this.trip,
    required this.startDate,
    required this.endDate,
    required this.places,
  });

  factory TripWithPlacesModel.fromJson(Map<String, dynamic> json) {
    final startDate = DateTime.parse(json['StartDate']);
    final endDate = DateTime.parse(json['EndDate']);

    return TripWithPlacesModel(
      trip: Trip(
        id: json['TripId'],
        status: json['Status'],
        createdAt: startDate, // adapter mapping (DO NOT change Trip)
        completedAt: json['Status'] == 'COMPLETED' ? endDate : null,
      ),
      startDate: startDate,
      endDate: endDate,
      places: (json['Places'] as List? ?? [])
          .map<TripPlace>(
            (e) => TripPlaceModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

    factory TripWithPlacesModel.fromTripModel(Trip model) {
    return TripWithPlacesModel(
      trip: model, // TripModel extends Trip → SAFE
      startDate: model.createdAt,
      endDate: model.completedAt ?? model.createdAt,
      places:   const [],
    );
  }
}
