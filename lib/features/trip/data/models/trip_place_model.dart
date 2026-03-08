import '../../domain/entities/trip_place.dart';

/// ---------------------------------------------------------------------------
/// TripPlaceModel
/// ---------------------------------------------------------------------------
/// Data model representing a specific place within a trip itinerary.
///
/// Extends the [TripPlace] entity to bridge the gap between backend
/// JSON data and the domain layer.
/// ---------------------------------------------------------------------------
class TripPlaceModel extends TripPlace {
  TripPlaceModel({
    required super.scheduleId,
    required super.placeId,
    required super.placeName,
    required super.scheduledDate,
    required super.status,
    super.startTime,
    super.endTime,
  });

  /// -------------------------------------------------------------------------
  /// Factory: fromJson
  /// -------------------------------------------------------------------------
  /// Converts a JSON [Map] into a [TripPlaceModel] instance.
  ///
  /// Key Logic:
  /// - Numeric Casting: Uses `(as num).toInt()` for IDs to prevent
  ///   type errors between double/int formats in JSON.
  /// - Default Values: Provides 'Unknown' for [placeName] and
  ///   'PENDING' for [status] if the fields are missing.
  /// - Date Parsing: Converts 'ScheduledDate' string into a [DateTime] object.
  factory TripPlaceModel.fromJson(Map<String, dynamic> json) {
    return TripPlaceModel(
      // Casting to num before toInt handles flexible JSON number formats
      scheduleId: (json['ScheduleId'] as num).toInt(),
      placeId: (json['PlaceId'] as num).toInt(),

      // Fallback for missing place names
      placeName: json['PlaceName'] as String? ?? 'Unknown',

      scheduledDate: DateTime.parse(json['ScheduledDate']),

      // Default status mapping
      status: json['Status'] as String? ?? 'PENDING',

      startTime: json['StartTime'] as String?,
      endTime: json['EndTime'] as String?,
    );
  }
}
