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
  final String startDate;
  final String endDate;

  SubmitTripRequest({
    required this.touristId,
    required this.agencyId,
    required this.startDate,
    required this.endDate,
  });
}


class SubmitTripWithPlaces extends TripEvent {
  final List<int> placeIds;

  SubmitTripWithPlaces({required this.placeIds});
}

class FetchAssignedEmployee extends TripEvent {}

class FetchCurrentTrip extends TripEvent {}