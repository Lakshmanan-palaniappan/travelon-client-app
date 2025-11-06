import 'dart:io';
import 'package:Travelon/core/utils/token_storage.dart';
import 'package:Travelon/features/auth/data/models/tourist_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../domain/entities/tourist.dart';
import '../../domain/usecases/register_tourist.dart';
import '../../domain/usecases/login_tourist.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterTourist registerTourist;
  final LoginTourist loginTourist;

  AuthBloc({required this.registerTourist, required this.loginTourist})
    : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginTouristEvent>(_onLogin);
  }

  /// Handle registration
  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await registerTourist(event.tourist, event.kycfile);

      if (response['status'] == 'success') {
        final message = response['message'] ?? {};

        // Some APIs return keys inside 'message', some inside 'data' → handle both
        await TokenStorage.saveAuthData(
          token: message['token'] ?? response['data']?['token'],
          refreshToken:
              message['refreshToken'] ?? response['data']?['refreshToken'],
          touristId:
              (message['TouristID'] ?? response['data']?['TouristID'])
                  ?.toString(),
          kycHash: message['KYCHash'] ?? response['data']?['KYCHash'],
        );

        emit(RegisterSuccess(response));
      } else {
        emit(
          AuthError(response['message']?.toString() ?? 'Registration failed'),
        );
      }
    } catch (e) {
      emit(AuthError('Registration failed: ${e.toString()}'));
    }
  }

  /// Handle login
  Future<void> _onLogin(
    LoginTouristEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await loginTourist(event.username, event.password);

      if (response['status'] == 'success') {
        final message = response['message'] ?? {};

        final user = message['user'] ?? {};
        await TokenStorage.saveAuthData(
          token: message['token'] ?? response['data']?['token'],
          refreshToken:
              message['refreshToken'] ?? response['data']?['refreshToken'],
          touristId:
              (user['ReferenceID'] ?? response['data']?['ReferenceID'])
                  ?.toString(),
          kycHash: message['KYCHash'],
        );

        emit(LoginSuccess(response));
      } else {
        emit(AuthError(response['message']?.toString() ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }
}
