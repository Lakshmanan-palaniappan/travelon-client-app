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

/// 🔹 When trip request is created successfully
class TripRequestSuccess extends TripState {
  final String message;
  TripRequestSuccess(this.message);
}

/// 🔹 When trip request fails
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

/// NEW → trip exists
class CurrentTripLoaded extends TripState {
  final CurrentTrip trip;
  CurrentTripLoaded(this.trip);
}


/// NEW → no ongoing trip
class NoCurrentTrip extends TripState {}

