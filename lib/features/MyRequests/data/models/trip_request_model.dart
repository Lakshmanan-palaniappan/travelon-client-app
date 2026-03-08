import '../../domain/entities/trip_request.dart';

/// ---------------------------------------------------------------------------
/// TripRequestModel
/// ---------------------------------------------------------------------------
/// The Data layer representation of a trip request.
/// 
/// Extends [TripRequest] to maintain architectural consistency while 
/// providing the necessary logic to serialize/deserialize API data.
/// ---------------------------------------------------------------------------
class TripRequestModel extends TripRequest {
  TripRequestModel({
    required super.requestId,
    required super.startDate,
    required super.endDate,
    required super.status,
    super.agencyName,
    super.employeeName,
    required super.places,
  });

  /// -------------------------------------------------------------------------
  /// Factory: fromJson
  /// -------------------------------------------------------------------------
  /// Converts a [Map<String, dynamic>] from the API into a [TripRequestModel].
  /// 
  /// Key Transformations:
  /// - Date Parsing: Converts ISO8601 strings into [DateTime] objects.
  /// - Nested Mapping: Iterates through the 'Places' list to create 
  ///   [RequestPlace] objects.
  /// - Null Safety: Provides an empty list fallback if 'Places' is null.
  /// -------------------------------------------------------------------------
  factory TripRequestModel.fromJson(Map<String, dynamic> json) {
    return TripRequestModel(
      requestId: json['RequestId'],
      startDate: DateTime.parse(json['StartDate']),
      endDate: DateTime.parse(json['EndDate']),
      status: json['Status'],
      agencyName: json['AgencyName'],
      employeeName: json['EmployeeName'],
      places: (json['Places'] as List? ?? [])
          .map((e) => RequestPlace(
        placeId: e['PlaceId'],
        placeName: e['PlaceName'],
        city: e['City'],
        state: e['State'],
        country: e['Country'],
      ))
          .toList(),
    );
  }
}