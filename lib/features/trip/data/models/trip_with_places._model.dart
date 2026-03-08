import '../../domain/entities/trip.dart';
import '../../domain/entities/trip_place.dart';
import 'trip_place_model.dart';

/// ---------------------------------------------------------------------------
/// TripWithPlacesModel
/// ---------------------------------------------------------------------------
/// A composite data model that wraps a [Trip] entity along with its
/// collection of [TripPlace] objects.
///
/// This is used when the UI needs to display a full itinerary view
/// including all scheduled stops and their specific details.
/// ---------------------------------------------------------------------------
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

  /// -------------------------------------------------------------------------
  /// Factory: fromJson
  /// -------------------------------------------------------------------------
  /// Creates a [TripWithPlacesModel] from a JSON [Map].
  ///
  /// Logic Details:
  /// - Date Parsing: Handles missing 'EndDate' by falling back to [startDate].
  /// - Places Mapping: Safely maps 'Places' JSON list into [TripPlaceModel].
  /// - Inline Entity Creation: Constructs a [Trip] entity directly from
  ///   the top-level JSON fields.
  factory TripWithPlacesModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['Places'];

    final startDate = DateTime.parse(json['StartDate']);

    // Fallback: If EndDate is null in JSON, use StartDate as the default
    final endDate =
        json['EndDate'] != null ? DateTime.parse(json['EndDate']) : startDate;

    // Robust list mapping with null-check
    final mappedPlaces =
        rawList != null
            ? (rawList as List)
                .map<TripPlace>(
                  (e) => TripPlaceModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
            : <TripPlace>[];

    return TripWithPlacesModel(
      // Constructing the domain Trip entity using parsed data
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

  /// -------------------------------------------------------------------------
  /// Factory: fromTripModel
  /// -------------------------------------------------------------------------
  /// Converts a standard [Trip] model into a [TripWithPlacesModel].
  ///
  /// Note: This initializes the [places] list as empty.
  /// Used primarily for UI placeholders or initial state management.
  factory TripWithPlacesModel.fromTripModel(Trip model) {
    return TripWithPlacesModel(
      trip: model,
      startDate: model.startDate,
      endDate: model.completedAt ?? model.endDate,
      places: const [],
    );
  }
}
