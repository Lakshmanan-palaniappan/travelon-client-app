
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

    final rawList = json['Places'];

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
      trip: model, 
      startDate: model.startDate,
      endDate: model.completedAt ?? model.endDate,
      places: const [],
    );
  }
}
