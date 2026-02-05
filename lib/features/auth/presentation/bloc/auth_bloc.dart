import 'dart:async';
import 'dart:io';

import 'package:Travelon/features/auth/data/models/tourist_model.dart';
import 'package:Travelon/features/auth/domain/entities/register_tourist.dart';
import 'package:Travelon/features/auth/domain/usecases/change_password.dart';
import 'package:Travelon/features/auth/domain/usecases/updatetourist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'package:Travelon/core/utils/token_storage.dart';
import 'package:Travelon/features/auth/domain/entities/tourist.dart';
import 'package:Travelon/features/auth/domain/usecases/forgot_password.dart';
import 'package:Travelon/features/auth/domain/usecases/get_tourist_details.dart';
import 'package:Travelon/features/auth/domain/usecases/login_tourist.dart';
import 'package:Travelon/features/auth/domain/usecases/register_tourist.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterTourist registerTourist;
  final LoginTourist loginTourist;
  final GetTouristDetails getTouristDetails;
  final ForgotPassword forgotPassword;
  final ChangePassword changePassword;
  final UpdateTourist updateTourist;

  AuthBloc({
    required this.registerTourist,
    required this.loginTourist,
    required this.getTouristDetails,
    required this.forgotPassword,
    required this.changePassword,
    required this.updateTourist,
  }) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginTouristEvent>(_onLogin);
    on<GetTouristDetailsEvent>(_onGetTouristDetails);
    on<LoadAuthFromStorage>(_onLoadAuthFromStorage);
    on<LogoutEvent>(_onLogout);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<ChangePasswordEvent>(_onChangePassword);

    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  // =========================
  // Register
  // =========================
  // Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
  //   emit(AuthLoading());

  //   try {
  //     if (event.kycfile == null) {
  //       emit(AuthError("KYC file is required"));
  //       return;
  //     }

  //     // ✅ Convert Register Entity → Model
  //     final touristModel = TouristModel.fromRegisterEntity(event.data);

  //     final response = await registerTourist(event.data, event.kycfile!);

  //     if (response['status']?.toString().toLowerCase() == 'success') {
  //       final data = response['data'];

  //       // ✅ API → Model → Entity
  //       final Tourist tourist = TouristModel.fromJson(data).toEntity();

  //       await TokenStorage.saveAuthData(
  //         token: data['token'] ?? '',
  //         refreshToken: data['refreshToken'] ?? '',
  //         touristId: tourist.id,
  //         kycURL: tourist.kycUrl,
  //         agencyId: tourist.agencyId.toString(),
  //       );

  //       await TokenStorage.saveTourist(tourist);

  //       emit(AuthSuccess(tourist));
  //     } else {
  //       emit(AuthError(response['message'] ?? "Registration failed"));
  //     }
  //   } catch (e) {
  //     emit(AuthError("Registration failed: ${e.toString()}"));
  //   }
  // }
Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
  emit(AuthLoading());

  try {
    if (event.kycfile == null) {
      emit(AuthError("KYC file is required"));
      return;
    }

    final response = await registerTourist(event.data, event.kycfile!);

    if (response['status']?.toString().toLowerCase() == 'success') {
      // ✅ DO NOT save token
      // ✅ DO NOT save tourist
      // ✅ DO NOT emit AuthSuccess

      emit(RegisterSuccess(response));
    } else {
      emit(AuthError(response['message']?.toString() ?? "Registration failed"));
    }
  } catch (e) {
    emit(AuthError("Registration failed: ${e.toString()}"));
  }
}

  // =========================
  // Login
  // =========================
  Future<void> _onLogin(
    LoginTouristEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final response = await loginTourist(event.username, event.password);

      if ((response['status']?.toString().toLowerCase()) == 'success') {
        final message = response['message'] is Map ? response['message'] : {};
        final data = response['data'] is Map ? response['data'] : {};
        final user = message['user'] ?? data['user'] ?? {};

        final token = message['token'] ?? data['token'];
        debugPrint('Token is ${token}');
        final refreshToken = message['refreshToken'] ?? data['refreshToken'];
        final touristId =
            (user['ReferenceID'] ?? data['ReferenceID'])?.toString();
        final kycURL = message['KycURL'] ?? data['KycURL'];
        final agencyId = message['AgencyId'] ?? data['AgencyId'];

        await TokenStorage.saveAuthData(
          token: token,
          refreshToken: refreshToken,
          touristId: touristId,
          kycURL: kycURL,
          agencyId: agencyId?.toString(),
        );

        if (touristId == null || touristId.isEmpty) {
          emit(AuthError("Tourist ID missing"));
          return;
        }

        final Tourist tourist = await getTouristDetails(touristId);
        await TokenStorage.saveTourist(tourist);

        emit(AuthSuccess(tourist));
      } else {
        emit(AuthError(response['message']?.toString() ?? "Login failed"));
      }
    } catch (_) {
      emit(AuthError("Login failed. Please try again."));
    }
  }

  // =========================
  // Load from storage
  // =========================
// Future<void> _onLoadAuthFromStorage(
//   LoadAuthFromStorage event,
//   Emitter<AuthState> emit,
// ) async {
//   emit(AuthLoading());
//
//   try {
//     final token = await TokenStorage.getToken();
//     final tourist = await TokenStorage.getTourist();
//
//     if (token != null && token.isNotEmpty && tourist != null) {
//       emit(AuthSuccess(tourist));
//     } else {
//       emit(AuthInitial());
//     }
//   } catch (_) {
//     emit(AuthInitial());
//   }
// }
  Future<void> _onLoadAuthFromStorage(
      LoadAuthFromStorage event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      final token = await TokenStorage.getToken();
      final touristId = await TokenStorage.getTouristId(); // 👈 get ID only

      if (token != null && token.isNotEmpty && touristId != null && touristId.isNotEmpty) {
        // 🔥 Always fetch fresh tourist from API
        final Tourist tourist = await getTouristDetails(touristId);

        // 🔁 Save fresh full tourist (with KYC, agency, etc.)
        await TokenStorage.saveTourist(tourist);

        emit(AuthSuccess(tourist));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }


  // =========================
  // Fetch tourist details
  // =========================
  Future<void> _onGetTouristDetails(
    GetTouristDetailsEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final tourist = await getTouristDetails(event.touristId);
      emit(GetTouristDetailsSuccess(tourist));
    } catch (_) {
      emit(AuthError("Failed to load tourist details"));
    }
  }

  // =========================
  // Logout
  // =========================
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
  await TokenStorage.clear();

  // 🔥 Clear registration draft
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('registration_draft');

  emit(AuthInitial());
}


  // =========================
  // Forgot password
  // =========================
  Future<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await forgotPassword(event.email);
      emit(AuthMessage("Password reset link sent to your email"));
    } catch (_) {
      emit(AuthError("Failed to send reset link"));
    }
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await changePassword(
        touristId: event.touristId,
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      );

      emit(AuthMessage("Password changed successfully"));
      await TokenStorage.clear();

      emit(AuthPasswordChanged());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfileEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      await updateTourist(event.touristId, event.data);

      // 🔁 Refresh tourist data
      final updatedTourist = await getTouristDetails(event.touristId);
      await TokenStorage.saveTourist(updatedTourist);

      // ✅ ONLY emit AuthSuccess
      emit(AuthSuccess(updatedTourist));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

}
