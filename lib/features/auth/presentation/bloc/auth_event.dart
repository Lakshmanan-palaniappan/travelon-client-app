part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final TouristModel tourist;
  final File kycfile;

  RegisterEvent(this.tourist,this.kycfile);
}

class LoginTouristEvent extends AuthEvent {
  final String username;
  final String password;

  LoginTouristEvent(this.username, this.password,);
}