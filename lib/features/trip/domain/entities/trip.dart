import 'package:Travelon/features/trip/domain/entities/trip_place.dart';

/// ---------------------------------------------------------------------------
/// Trip
/// ---------------------------------------------------------------------------
/// The base domain entity representing a Trip in the Travelon system.
/// 
/// This class defines the core properties shared by all trip variations,
/// including timing, status tracking, and optional destination data.
/// ---------------------------------------------------------------------------
class Trip {
  final int id;
  
  /// Current state of the trip. 
  /// Expected values: 'ONGOING', 'COMPLETED', or 'PENDING'.
  final String status; 
  
  final DateTime startDate;
  final DateTime endDate;
  
  /// Optional timestamp indicating when the trip was officially finished.
  final DateTime? completedAt;
  
  /// Optional list of destinations associated with this trip.
  final List<TripPlace>? places;

  Trip({
    required this.id,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.completedAt,
    this.places,
  });
}