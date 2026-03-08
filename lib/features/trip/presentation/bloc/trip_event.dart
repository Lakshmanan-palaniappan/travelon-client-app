part of 'trip_bloc.dart';

@immutable
abstract class TripEvent {}

/// ---------------------------------------------------------------------------
/// FetchAgencyPlaces
/// ---------------------------------------------------------------------------
/// Triggered when the user selects an agency and needs to see the 
/// catalog of places they offer.
/// ---------------------------------------------------------------------------
class FetchAgencyPlaces extends TripEvent {
  final String agencyId;
  FetchAgencyPlaces(this.agencyId);
}

/// ---------------------------------------------------------------------------
/// SubmitTripRequest
/// ---------------------------------------------------------------------------
/// Initiates the first step of the booking process by sending the 
/// desired dates and agency selection to the backend.
/// ---------------------------------------------------------------------------
class SubmitTripRequest extends TripEvent {
  final String touristId;
  final String agencyId;
  final String startDate; // Format: DD/MM/YYYY
  final String endDate;   // Format: DD/MM/YYYY

  SubmitTripRequest({
    required this.touristId,
    required this.agencyId,
    required this.startDate,
    required this.endDate,
  });
}

/// ---------------------------------------------------------------------------
/// SubmitTripWithPlaces
/// ---------------------------------------------------------------------------
/// Finalizes the trip by submitting the specific list of chosen 
/// place IDs for the pending request.
/// ---------------------------------------------------------------------------
class SubmitTripWithPlaces extends TripEvent {
  final List<int> placeIds;

  SubmitTripWithPlaces({required this.placeIds});
}

/// ---------------------------------------------------------------------------
/// FetchAssignedEmployee
/// ---------------------------------------------------------------------------
/// Requests details about the guide or driver assigned to the user's active trip.
/// ---------------------------------------------------------------------------
class FetchAssignedEmployee extends TripEvent {}

/// ---------------------------------------------------------------------------
/// FetchCurrentTrip
/// ---------------------------------------------------------------------------
/// Checks for any active trip associated with the logged-in user.
/// ---------------------------------------------------------------------------
class FetchCurrentTrip extends TripEvent {}

/// ---------------------------------------------------------------------------
/// FetchTouristTrips
/// ---------------------------------------------------------------------------
/// Retrieves a high-level list of all trips the user has ever taken.
/// ---------------------------------------------------------------------------
class FetchTouristTrips extends TripEvent {
  final String touristId;
  FetchTouristTrips(this.touristId);
}

/// ---------------------------------------------------------------------------
/// FetchTouristTripsWithPlaces
/// ---------------------------------------------------------------------------
/// Retrieves a detailed history of trips, including the specific 
/// itinerary (places) for each trip.
/// ---------------------------------------------------------------------------
class FetchTouristTripsWithPlaces extends TripEvent {
  final String touristId;

  FetchTouristTripsWithPlaces(this.touristId);
}