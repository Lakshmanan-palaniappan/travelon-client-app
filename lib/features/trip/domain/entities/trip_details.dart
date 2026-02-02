import 'trip.dart';
import 'trip_place.dart';

class TripDetails extends Trip {
  final List<TripPlace> places;

  TripDetails({
    required int id,
    required String status,
    required DateTime startDate,
    required DateTime endDate,
    DateTime? completedAt,
    required this.places,
  }) : super(
          id: id,
          status: status,
          startDate: startDate,
          endDate: endDate,
          completedAt: completedAt,
          places: places,
        );
}
