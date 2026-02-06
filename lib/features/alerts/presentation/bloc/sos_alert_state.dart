import '../../domain/entities/sos_alert.dart';

abstract class SosAlertState {}

class SosAlertInitial extends SosAlertState {}
class SosAlertLoading extends SosAlertState {}

class SosAlertLoaded extends SosAlertState {
  final List<SosAlert> items;
  SosAlertLoaded(this.items);
}

class SosAlertError extends SosAlertState {
  final String message;
  SosAlertError(this.message);
}
