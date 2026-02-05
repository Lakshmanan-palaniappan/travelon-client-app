import 'package:meta/meta.dart';
import '../../domain/entities/trip_request.dart';

@immutable
abstract class MyRequestsState {}

class MyRequestsInitial extends MyRequestsState {}

class MyRequestsLoading extends MyRequestsState {}

class MyRequestsLoaded extends MyRequestsState {
  final List<TripRequest> requests;
  MyRequestsLoaded(this.requests);
}

class MyRequestsError extends MyRequestsState {
  final String message;
  MyRequestsError(this.message);
}
