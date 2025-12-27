abstract class SosState {}

class SosInitial extends SosState {}

class SosSending extends SosState {}

class SosSuccess extends SosState {
  final String source; // gps / wifi
  SosSuccess(this.source);
}

class SosError extends SosState {
  final String message;
  SosError(this.message);
}
