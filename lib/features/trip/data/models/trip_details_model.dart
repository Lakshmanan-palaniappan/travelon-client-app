import 'package:Travelon/features/trip/data/models/trip_place_model.dart';
import '../../domain/entities/trip_details.dart';

/// ---------------------------------------------------------------------------
/// TripDetailsModel
/// ---------------------------------------------------------------------------
/// Data model for detailed Trip information, extending the [TripDetails] entity.
///
/// This model acts as the glue between the backend JSON structure and the
/// high-level domain representation used in the UI and BLoC.
/// ---------------------------------------------------------------------------
class TripDetailsModel extends TripDetails {
  TripDetailsModel({
    required super.id,
    required super.status,
    required super.startDate,
    required super.endDate,
    required super.completedAt,
    required super.places,
  });

  /// -------------------------------------------------------------------------
  /// Factory: fromJson
  /// -------------------------------------------------------------------------
  /// Creates a [TripDetailsModel] from a JSON [Map].
  ///
  /// Key Logic:
  /// - Parses [DateTime] strings from the backend.
  /// - [completedAt] logic: If the trip [status] is 'COMPLETED', it assigns
  ///   the [endDate] as the completion timestamp.
  /// - Maps the 'Places' list into a list of [TripPlaceModel] instances.
  factory TripDetailsModel.fromJson(Map<String, dynamic> json) {
    final startDate = DateTime.parse(json['StartDate']);
    final endDate = DateTime.parse(json['EndDate']);
    final status = json['Status'];

    return TripDetailsModel(
      id: json['TripId'],
      status: status,
      startDate: startDate,
      endDate: endDate,

      // Business Logic: Derived completion status
      completedAt: status == 'COMPLETED' ? endDate : null,

      // Nested Object Mapping
      places:
          (json['Places'] as List)
              .map((e) => TripPlaceModel.fromJson(e))
              .toList(),
    );
  }
}
