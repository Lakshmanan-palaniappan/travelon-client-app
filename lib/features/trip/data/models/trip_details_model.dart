import 'package:Travelon/features/trip/data/models/trip_place_model.dart';
import '../../domain/entities/trip_details.dart';

class TripDetailsModel extends TripDetails {
  TripDetailsModel({
    required super.id,
    required super.status,
    required super.startDate,
    required super.endDate,
    required super.completedAt,
    required super.places,
  });

  factory TripDetailsModel.fromJson(Map<String, dynamic> json) {
    final startDate = DateTime.parse(json['StartDate']);
    final endDate = DateTime.parse(json['EndDate']);
    final status = json['Status'];

    return TripDetailsModel(
      id: json['TripId'],
      status: status,
      startDate: startDate,
      endDate: endDate,
      completedAt:
          status == 'COMPLETED'
              ? endDate
              : null,
      places: (json['Places'] as List)
          .map((e) => TripPlaceModel.fromJson(e))
          .toList(),
    );
  }
}
