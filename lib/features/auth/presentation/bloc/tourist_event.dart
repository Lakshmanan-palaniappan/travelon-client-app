part of 'tourist_bloc.dart';

abstract class TouristEvent {}

class RegisterTouristEvent extends TouristEvent {
  final Tourist tourist;
  final File kycFile;

  RegisterTouristEvent(this.tourist, this.kycFile);
}
