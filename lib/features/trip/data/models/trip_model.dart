// import '../../domain/entities/trip.dart';

// class TripModel extends Trip {
//   TripModel({
//     required super.id,
//     required super.status,
//     required super.createdAt,
//     super.completedAt,
//   });

//   factory TripModel.fromJson(Map<String, dynamic> json) {
//     return TripModel(
//       id: json['id'],
//       status: json['status'],
//       createdAt: DateTime.parse(json['createdAt']),
//       completedAt: json['completedAt'] != null
//           ? DateTime.parse(json['completedAt'])
//           : null,
//     );
//   }
// }

import 'package:Travelon/features/trip/data/models/trip_place_model.dart';

import '../../domain/entities/trip.dart';

class TripModel extends Trip {
  TripModel({
    required super.id,
    required super.status,
    required super.createdAt,
    super.completedAt,
    super.places,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['TripId'], // 🔁 map TripId → id

      status: _mapStatus(json['Status']),

      // backend doesn't send createdAt → derive safely
      createdAt: DateTime.parse(json['StartDate']),

      // completed only if finished
      completedAt:
          _isCompleted(json['Status']) ? DateTime.parse(json['EndDate']) : null,
      places:
          (json['Places'] as List?)
              ?.map((e) => TripPlaceModel.fromJson(e))
              .toList(),
    );
  }

  static bool _isCompleted(String? status) {
    return status?.toUpperCase() == 'COMPLETED';
  }

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
