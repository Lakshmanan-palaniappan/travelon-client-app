part of 'location_bloc.dart';

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final LocationResult location;
  LocationLoaded(this.location);
}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}
