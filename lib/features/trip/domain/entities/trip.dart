import 'package:Travelon/features/trip/domain/entities/trip_place.dart';

class Trip {
  final int id;
  final String status; // ONGOING | COMPLETED | PENDING
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? completedAt;
  final List<TripPlace>? places;

  Trip( {
    required this.id,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.completedAt,
    this.places,
  });
}
