part of 'trip_bloc.dart';

@immutable
abstract class TripEvent {}

class FetchAgencyPlaces extends TripEvent {
  final String agencyId;
  FetchAgencyPlaces(this.agencyId);
}
class SubmitTripRequest extends TripEvent {
  final String touristId;
  final String agencyId;
  final List<int> placeIds;

  SubmitTripRequest({
    required this.touristId,
    required this.agencyId,
    this.placeIds = const [],
  });
}
class SubmitTripWithPlaces extends TripEvent {
  final String touristId;
  final String agencyId;
  final List<int> placeIds;

  SubmitTripWithPlaces({
    required this.touristId,
    required this.agencyId,
    required this.placeIds,
  });
}