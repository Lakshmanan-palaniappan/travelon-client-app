import 'package:Travelon/features/trip/data/models/trip_place_model.dart';
import '../../domain/entities/trip.dart';

/// ---------------------------------------------------------------------------
/// TripModel
/// ---------------------------------------------------------------------------
/// Data model for a Trip, extending the [Trip] domain entity.
///
/// This model includes logic to normalize backend status strings and
/// calculate completion dates based on trip status.
/// ---------------------------------------------------------------------------
class TripModel extends Trip {
  TripModel({
    required super.id,
    required super.status,
    required super.startDate,
    required super.endDate,
    super.completedAt,
    super.places,
  });

  /// -------------------------------------------------------------------------
  /// Factory: fromJson
  /// -------------------------------------------------------------------------
  /// Creates a [TripModel] from a JSON [Map].
  ///
  /// Key Transformations:
  /// - Normalizes [status] using [_mapStatus].
  /// - Conditionally sets [completedAt] using [_isCompleted].
  /// - Safely handles null or missing 'Places' lists.
  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['TripId'],

      // Data Normalization: Maps various backend strings to a standard status
      status: _mapStatus(json['Status']),

      startDate: DateTime.parse(json['StartDate']),
      endDate: DateTime.parse(json['EndDate']),

      // Logic: Trip is only considered completed if status matches 'COMPLETED'
      completedAt:
          _isCompleted(json['Status']) ? DateTime.parse(json['EndDate']) : null,

      // Null-safe mapping for nested place models
      places:
          (json['Places'] as List?)
              ?.map((e) => TripPlaceModel.fromJson(e))
              .toList(),
    );
  }

  /// -------------------------------------------------------------------------
  /// Helper: _isCompleted
  /// -------------------------------------------------------------------------
  /// Checks if the raw status string represents a finished trip.
  static bool _isCompleted(String? status) {
    return status?.toUpperCase() == 'COMPLETED';
  }

  /// -------------------------------------------------------------------------
  /// Helper: _mapStatus
  /// -------------------------------------------------------------------------
  /// Maps various backend status strings to a consistent internal set.
  ///
  /// - 'PLANNED' or 'PENDING' -> 'PENDING'
  /// - 'ONGOING' -> 'ONGOING'
  /// - 'COMPLETED' -> 'COMPLETED'
  /// - Default -> 'PENDING'
  static String _mapStatus(String? status) {
    switch (status?.toUpperCase()) {
      case 'PLANNED':
      case 'PENDING':
        return 'PENDING';
      case 'ONGOING':
        return 'ONGOING';
      case 'COMPLETED':
        return 'COMPLETED';
      default:
        return 'PENDING';
    }
  }
}
