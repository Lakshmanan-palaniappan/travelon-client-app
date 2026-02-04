part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final Tourist tourist;
  AuthSuccess(this.tourist);
}

class RegisterSuccess extends AuthState {
  final dynamic response;
  RegisterSuccess(this.response);
}

class GetTouristDetailsSuccess extends AuthState {
  final Tourist tourist;
  GetTouristDetailsSuccess(this.tourist);
}

class AuthError extends AuthState {
  final String error;
  AuthError(this.error);
}

class AuthMessage extends AuthState {
  final String message;
  AuthMessage(this.message);
}
