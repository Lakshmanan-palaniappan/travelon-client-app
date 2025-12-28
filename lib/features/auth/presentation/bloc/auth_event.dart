part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final RegisterTouristEntity data;
  final File? kycfile;

  RegisterEvent(this.data, {this.kycfile});
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

class LogoutEvent extends AuthEvent {}

class ForgotPasswordEvent extends AuthEvent {
  final String email;
  ForgotPasswordEvent(this.email);
}

class ChangePasswordEvent extends AuthEvent {
  final String touristId;
  final String oldPassword;
  final String newPassword;

  ChangePasswordEvent({
    required this.touristId,
    required this.oldPassword,
    required this.newPassword,
  });
}

class AuthPasswordChanged extends AuthState {}


class UpdateProfileEvent extends AuthEvent {
  final String touristId;
  final Map<String, dynamic> data;

  UpdateProfileEvent({
    required this.touristId,
    required this.data,
  });
}





