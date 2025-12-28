import '../../domain/entities/trip.dart';

class TripModel extends Trip {
  TripModel({
    required super.id,
    required super.status,
    required super.createdAt,
    super.completedAt,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }
}
