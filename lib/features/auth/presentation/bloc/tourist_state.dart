part of 'tourist_bloc.dart';

abstract class TouristState {}

class TouristInitial extends TouristState {}
class TouristLoading extends TouristState {}
class TouristRegistered extends TouristState {
  final Map<String, dynamic> response;
  TouristRegistered(this.response);
}
class TouristError extends TouristState {
  final String message;
  TouristError(this.message);
}
