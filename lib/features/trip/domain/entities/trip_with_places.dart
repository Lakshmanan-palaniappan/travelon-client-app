import 'package:Travelon/features/trip/data/models/trip_model.dart';
import 'package:Travelon/features/trip/data/models/trip_place_model.dart';
import 'trip.dart';
import 'trip_place.dart';

/// ---------------------------------------------------------------------------
/// TripWithPlaces
/// ---------------------------------------------------------------------------
/// A composite domain entity that pairs a [Trip] with its associated 
/// list of [TripPlace] objects.
/// 
/// This is used to represent the full "Package" of a trip, including 
/// the core trip metadata and every scheduled destination.
/// ---------------------------------------------------------------------------
class TripWithPlaces {
  final Trip trip;
  final List<TripPlace> places;

  TripWithPlaces({
    required this.trip,
    required this.places,
  });

  /// -------------------------------------------------------------------------
  /// Factory: fromJson
  /// -------------------------------------------------------------------------
  /// Constructs a [TripWithPlaces] instance by delegating to specific 
  /// model factories.
  /// 
  /// Key Logic:
  /// - Trip Mapping: Uses [TripModel.fromJson] to parse the base trip data.
  /// - Places Mapping: Safely converts the 'Places' list using 
  ///   [TripPlaceModel.fromJson]. 
  /// - Null Safety: Defaults to an empty list if 'Places' is missing.
  factory TripWithPlaces.fromJson(Map<String, dynamic> json) {
    return TripWithPlaces(
      // Delegate core trip parsing to the specialized TripModel factory
      trip: TripModel.fromJson(json),
      
      // Efficiently map the nested list while handling null cases
      places: (json['Places'] as List? ?? [])
          .map((e) => TripPlaceModel.fromJson(e))
          .toList(),
    );
  }
}