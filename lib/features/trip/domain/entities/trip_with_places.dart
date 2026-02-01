import 'package:Travelon/features/trip/data/models/trip_model.dart';
import 'package:Travelon/features/trip/data/models/trip_place_model.dart';



import 'trip.dart';
import 'trip_place.dart';

class TripWithPlaces {
  final Trip trip;
  final List<TripPlace> places;

  TripWithPlaces({
    required this.trip,
    required this.places,
  });


  factory TripWithPlaces.fromJson(Map<String, dynamic> json) {
    return TripWithPlaces(
      trip: TripModel.fromJson(json),
      places: (json['Places'] as List? ?? [])
          .map((e) => TripPlaceModel.fromJson(e))
          .toList(),
    );
  }
}
