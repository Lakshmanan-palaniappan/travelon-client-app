import 'package:Travelon/features/trip/data/models/trip_model.dart';
import 'package:Travelon/features/trip/data/models/trip_place_model.dart';



class TripWithPlaces {
  final TripModel trip;
  final List<TripPlaceModel> places;

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
