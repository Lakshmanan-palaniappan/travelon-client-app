part of 'trip_bloc.dart';

@immutable
abstract class TripState {}

/// ---------------------------------------------------------------------------
/// Base States
/// ---------------------------------------------------------------------------
class TripInitial extends TripState {}

/// General loading state for place discovery or trip creation
class TripLoading extends TripState {}

/// State emitted when the catalog of agency places is successfully retrieved
class TripLoaded extends TripState {
  final List<dynamic> places;
  TripLoaded(this.places);
}

/// Generic error state for trip-related operations
class TripError extends TripState {
  final String message;
  TripError(this.message);
}

/// ---------------------------------------------------------------------------
/// Trip Request & Submission States
/// ---------------------------------------------------------------------------
/// Emitted upon successful Step 1 (Request) or Step 2 (Selection)
class TripRequestSuccess extends TripState {
  final String message;
  TripRequestSuccess(this.message);
}

class TripRequestError extends TripState {
  final String message;
  TripRequestError(this.message);
}

/// ---------------------------------------------------------------------------
/// Employee Assignment States
/// ---------------------------------------------------------------------------
class AssignedEmployeeLoading extends TripState {}

class AssignedEmployeeLoaded extends TripState {
  final AssignedEmployee? employee;
  AssignedEmployeeLoaded(this.employee);
}

class AssignedEmployeeError extends TripState {
  final String message;
  AssignedEmployeeError(this.message);
}

/// ---------------------------------------------------------------------------
/// Active Trip Tracking States
/// ---------------------------------------------------------------------------
class CurrentTripLoading extends TripState {}

/// Emitted when an active, ongoing trip is found for the user
class CurrentTripLoaded extends TripState {
  final CurrentTrip trip;
  CurrentTripLoaded(this.trip);
}

/// Explicit state for when the user has no active trips scheduled
class NoCurrentTrip extends TripState {}

/// ---------------------------------------------------------------------------
/// Trip History States
/// ---------------------------------------------------------------------------
class TouristTripsLoading extends TripState {}

/// State for a summarized list of past trips
class TouristTripsLoaded extends TripState {
  final List<Trip> trips;
  TouristTripsLoaded(this.trips);
}

/// State for a detailed list of past trips including full itineraries
class TouristTripsWithPlacesLoaded extends TripState {
  final List<TripWithPlaces> trips;

  TouristTripsWithPlacesLoaded(this.trips);
}