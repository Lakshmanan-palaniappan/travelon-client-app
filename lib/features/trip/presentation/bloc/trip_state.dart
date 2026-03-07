part of 'trip_bloc.dart';

@immutable
abstract class TripState {}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripLoaded extends TripState {
  final List<dynamic> places;
  TripLoaded(this.places);
}

class TripError extends TripState {
  final String message;
  TripError(this.message);
}

class TripRequestSuccess extends TripState {
  final String message;
  TripRequestSuccess(this.message);
}

class TripRequestError extends TripState {
  final String message;
  TripRequestError(this.message);
}


class AssignedEmployeeLoading extends TripState {}

class AssignedEmployeeLoaded extends TripState {
  final AssignedEmployee? employee;
  AssignedEmployeeLoaded(this.employee);
}

class AssignedEmployeeError extends TripState {
  final String message;
  AssignedEmployeeError(this.message);
}

class CurrentTripLoading extends TripState {}

class CurrentTripLoaded extends TripState {
  final CurrentTrip trip;
  CurrentTripLoaded(this.trip);
}


class NoCurrentTrip extends TripState {}



class TouristTripsLoading extends TripState {}

class TouristTripsLoaded extends TripState {
  final List<Trip> trips;
  TouristTripsLoaded(this.trips);
}


class TouristTripsWithPlacesLoaded extends TripState {
  final List<TripWithPlaces> trips;

  TouristTripsWithPlacesLoaded(this.trips);
}


