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
