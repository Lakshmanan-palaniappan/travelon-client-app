import '../../domain/entities/trip_request.dart';

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
