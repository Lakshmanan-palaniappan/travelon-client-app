part of 'location_bloc.dart';

abstract class LocationEvent {}

class GetLocationEvent extends LocationEvent {
  final int touristId;
  GetLocationEvent(this.touristId);
}
