import 'trip.dart';
import 'trip_place.dart';

/// ---------------------------------------------------------------------------
/// TripDetails
/// ---------------------------------------------------------------------------
/// A specialized domain entity that extends [Trip] to include a mandatory 
/// list of [TripPlace] objects.
/// 
/// This entity is typically used for "Full View" screens where the complete 
/// itinerary and all associated stop details are required.
/// ---------------------------------------------------------------------------
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