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

  // factory TripWithPlacesModel.fromJson(Map<String, dynamic> json) {
  //   final startDate = DateTime.parse(json['StartDate']);
  //   final endDate = DateTime.parse(json['EndDate']);

  //   return TripWithPlacesModel(
  //     trip: Trip(
  //       id: json['TripId'],
  //       status: json['Status'],
  //       createdAt: startDate, // adapter mapping (DO NOT change Trip)
  //       completedAt: json['Status'] == 'COMPLETED' ? endDate : null,
  //     ),
  //     startDate: startDate,
  //     endDate: endDate,
  //     places: (json['Places'] as List? ?? [])
  //         .map<TripPlace>(
  //           (e) => TripPlaceModel.fromJson(e as Map<String, dynamic>),
  //         )
  //         .toList(),
  //   );
  // }

  factory TripWithPlacesModel.fromJson(Map<String, dynamic> json) {
    print("--- Debug Mapping ---");
    print("TripId: ${json['TripId']}");

    final rawList = json['Places'];
    print("Raw Places Type: ${rawList.runtimeType}");
    print(
      "Raw Places Length: ${rawList is List ? rawList.length : 'Not a list'}",
    );

    final startDate = DateTime.parse(json['StartDate']);
    final endDate =
        json['EndDate'] != null ? DateTime.parse(json['EndDate']) : startDate;

    final mappedPlaces =
        rawList != null
            ? (rawList as List)
                .map<TripPlace>(
                  (e) => TripPlaceModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
            : <TripPlace>[];

    print("Mapped Places Count: ${mappedPlaces.length}");

    return TripWithPlacesModel(
      trip: Trip(
        id: json['TripId'],
        status: json['Status'],
        startDate: startDate,
        endDate: endDate,
        completedAt: json['Status'] == 'COMPLETED' ? endDate : null,
      ),
      startDate: startDate,
      endDate: endDate,
      places: mappedPlaces,
    );
  }

  factory TripWithPlacesModel.fromTripModel(Trip model) {
    return TripWithPlacesModel(
      trip: model, // TripModel extends Trip → SAFE
      startDate: model.startDate,
      endDate: model.completedAt ?? model.endDate,
      places: const [],
    );
  }
}
