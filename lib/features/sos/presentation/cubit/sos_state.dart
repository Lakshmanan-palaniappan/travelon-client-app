abstract class SosState {}

class SosInitial extends SosState {}

class SosSending extends SosState {}

class SosSuccess extends SosState {
  final String source; // gps / wifi
  SosSuccess(this.source);
}

class SosError extends SosState {
  final String? message;
  final int? statusCode;
  final int? secondsRemaining;

  SosError({this.message, this.statusCode, this.secondsRemaining});
}