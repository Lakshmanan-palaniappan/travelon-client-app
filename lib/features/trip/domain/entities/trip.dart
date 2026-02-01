import 'package:Travelon/features/trip/domain/entities/trip_place.dart';

class Trip {
  final int id;
  final String status; // ONGOING | COMPLETED | PENDING
  final DateTime createdAt;
  final DateTime? completedAt;
  final List<TripPlace>? places;

  Trip( {
    required this.id,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.places,
  });
}
