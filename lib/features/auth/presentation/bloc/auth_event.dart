

part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final Tourist tourist;
  final File? kycfile;

  RegisterEvent(this.tourist, {this.kycfile});
}


class LoginTouristEvent extends AuthEvent {
  final String username;
  final String password;
  LoginTouristEvent(this.username, this.password);
}

class GetTouristDetailsEvent extends AuthEvent {
  final String touristId;
  GetTouristDetailsEvent(this.touristId);
}

class LoadAuthFromStorage extends AuthEvent {}

class LogoutEvent extends AuthEvent {
  
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;
  ForgotPasswordEvent(this.email);
}

