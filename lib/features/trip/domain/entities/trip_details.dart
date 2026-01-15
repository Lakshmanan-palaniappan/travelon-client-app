import 'trip.dart';
import 'trip_place.dart';

class TripDetails extends Trip {
  final List<TripPlace> places;

  TripDetails({
    required int id,
    required String status,
    required DateTime createdAt,
    DateTime? completedAt,
    required this.places,
  }) : super(
          id: id,
          status: status,
          createdAt: createdAt,
          completedAt: completedAt,
        );
}
