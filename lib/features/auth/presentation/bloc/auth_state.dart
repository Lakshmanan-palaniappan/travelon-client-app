part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

/// Success states
class LoginSuccess extends AuthState {
  final Map<String, dynamic> response;
  LoginSuccess(this.response);
}

class RegisterSuccess extends AuthState {
  final Map<String, dynamic> response;
  RegisterSuccess(this.response);
}

/// Error
class AuthError extends AuthState {
  final String error;
  AuthError(this.error);
}
