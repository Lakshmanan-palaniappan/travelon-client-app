// import 'dart:io';
// import 'package:Travelon/core/utils/token_storage.dart';
// import 'package:Travelon/features/auth/data/models/tourist_model.dart';
// import 'package:Travelon/features/auth/domain/entities/tourist.dart';
// import 'package:Travelon/features/auth/domain/usecases/get_tourist_details.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meta/meta.dart';
// import '../../domain/usecases/register_tourist.dart';
// import '../../domain/usecases/login_tourist.dart';

// part 'auth_event.dart';
// part 'auth_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final RegisterTourist registerTourist;
//   final LoginTourist loginTourist;
//   final GetTouristDetails getTouristDetails;

//   AuthBloc({
//     required this.registerTourist,
//     required this.loginTourist,
//     required this.getTouristDetails,
//   }) : super(AuthInitial()) {
//     on<RegisterEvent>(_onRegister);
//     on<LoginTouristEvent>(_onLogin);
//     on<GetTouristDetailsEvent>(_onGetTouristDetails);
//   }

//   /// Handle registration
//   Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
//     emit(AuthLoading());
//     try {
//       final response = await registerTourist(event.tourist, event.kycfile);

//       if (response['status'] == 'success') {
//         final message = response['message'] ?? {};

//         // Some APIs return keys inside 'message', some inside 'data' → handle both
//         await TokenStorage.saveAuthData(
//           token: message['token'] ?? response['data']?['token'],
//           refreshToken:
//               message['refreshToken'] ?? response['data']?['refreshToken'],
//           touristId:
//               (message['TouristID'] ?? response['data']?['TouristID'])
//                   ?.toString(),
//           kycHash: message['KYCHash'] ?? response['data']?['KYCHash'],
//         );

//         emit(RegisterSuccess(response));
//       } else {
//         emit(
//           AuthError(response['message']?.toString() ?? 'Registration failed'),
//         );
//       }
//     } catch (e) {
//       emit(AuthError('Registration failed: ${e.toString()}'));
//     }
//   }

//   /// Handle login
//   Future<void> _onLogin(
//     LoginTouristEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       // Step 1: Call the login API
//       final response = await loginTourist(event.username, event.password);

//       // Step 2: Handle both 'Success' and 'success'
//       final status = response['status']?.toString().toLowerCase();

//       if (status == 'success') {
//         final message =
//             (response['message'] is Map)
//                 ? response['message']
//                 : <String, dynamic>{};
//         final data =
//             (response['data'] is Map) ? response['data'] : <String, dynamic>{};

//         // Step 3: Extract tokens and IDs
//         final token = message['token'] ?? data['token'];
//         final refreshToken = message['refreshToken'] ?? data['refreshToken'];
//         final user = message['user'] is Map ? message['user'] : {};
//         final touristId =
//             (user['ReferenceID'] ?? data['ReferenceID'])?.toString();
//         final kycHash = message['KYCHash'] ?? data['KYCHash'];
//         final agencyId = message['AgencyId'] ?? data['AgencyId'];

//         // Step 4: Save tokens and IDs
//         await TokenStorage.saveAuthData(
//           token: token ?? '',
//           refreshToken: refreshToken ?? '',
//           touristId: touristId,
//           kycHash: kycHash,
//           agencyId: agencyId?.toString(),
//         );

//         // ✅ Step 5: Fetch detailed tourist info
//         if (touristId != null && touristId.isNotEmpty) {
//           final tourist = await getTouristDetails(touristId);
//           await TokenStorage.saveTourist(tourist); // Save full TouristModel
//           emit(AuthSuccess(tourist));

//           print("✅ Tourist details: $tourist");
//           print("✅ Agency ID: ${tourist.agencyId} | Tourist ID: ${tourist.id}");
//         } else {
//           emit(AuthError("Tourist ID missing in login response"));
//         }
//       } else {
//         emit(AuthError(response['message']?.toString() ?? 'Login failed'));
//       }
//     } catch (e, stackTrace) {
//       debugPrint("🔴 Login error: $e\n$stackTrace");
//       emit(AuthError('Login failed: ${e.toString()}'));
//     }
//   }

//   Future<void> _onGetTouristDetails(
//     GetTouristDetailsEvent event,
//     Emitter<AuthState> emit,
//   ) async {
//     emit(AuthLoading());
//     try {
//       final tourist = await getTouristDetails(event.touristId);
//       emit(GetTouristDetailsSuccess(tourist));
//     } catch (e) {
//       emit(AuthError('Failed to load tourist details: ${e.toString()}'));
//     }
//   }

// void _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
//   await TokenStorage.clear();
//   emit(AuthInitial()); // or navigate to login screen in UI
// }

// }

import 'dart:async';
import 'dart:io';
import 'package:Travelon/core/utils/token_storage.dart';
import 'package:Travelon/features/auth/data/models/tourist_model.dart';
import 'package:Travelon/features/auth/domain/entities/tourist.dart';
import 'package:Travelon/features/auth/domain/usecases/get_tourist_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../domain/usecases/register_tourist.dart';
import '../../domain/usecases/login_tourist.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterTourist registerTourist;
  final LoginTourist loginTourist;
  final GetTouristDetails getTouristDetails;

  AuthBloc({
    required this.registerTourist,
    required this.loginTourist,
    required this.getTouristDetails,
  }) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginTouristEvent>(_onLogin);
    on<GetTouristDetailsEvent>(_onGetTouristDetails);
    on<LoadAuthFromStorage>(_onLoadAuthFromStorage);
    on<LogoutEvent>(_onLogout);
  }

  /// =========================
  /// Handle registration
  /// =========================
  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      if (event.kycfile == null) {
        emit(AuthError("KYC file is required"));
        return;
      }

      final response = await registerTourist(event.tourist, event.kycfile!);

      if ((response['status']?.toString().toLowerCase() ?? '') == 'success') {
        final message =
            response['message'] is Map
                ? response['message']
                : <String, dynamic>{};

        await TokenStorage.saveAuthData(
          token: message['token'] ?? response['data']?['token'] ?? '',
          refreshToken:
              message['refreshToken'] ??
              response['data']?['refreshToken'] ??
              '',
          touristId:
              (message['TouristID'] ?? response['data']?['TouristID'])
                  ?.toString(),
          kycURL: message['KycURL'] ?? response['data']?['KycURL'],
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

  /// =========================
  /// Handle login
  /// =========================
  Future<void> _onLogin(
    LoginTouristEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await loginTourist(event.username, event.password);
      final status = response['status']?.toString().toLowerCase();

      if (status == 'success') {
        final message =
            response['message'] is Map
                ? response['message']
                : <String, dynamic>{};
        final data =
            response['data'] is Map ? response['data'] : <String, dynamic>{};
        final user =
            message['user'] is Map ? message['user'] : data['user'] ?? {};

        final token = message['token'] ?? data['token'] ?? '';
        final refreshToken =
            message['refreshToken'] ?? data['refreshToken'] ?? '';
        final touristId =
            (user['ReferenceID'] ?? data['ReferenceID'])?.toString();
        final kycURL = message['KycURL'] ?? data['KycURL'];
        final agencyId = message['AgencyId'] ?? data['AgencyId'];

        // Save tokens and IDs
        await TokenStorage.saveAuthData(
          token: token,
          refreshToken: refreshToken,
          touristId: touristId,
          kycURL: kycURL,
          agencyId: agencyId?.toString(),
        );

        // Fetch full tourist details
        if (touristId != null && touristId.isNotEmpty) {
          final tourist = await getTouristDetails(touristId);
          await TokenStorage.saveTourist(tourist);
          emit(AuthSuccess(tourist));
        } else {
          emit(AuthError("Tourist ID missing in login response"));
        }
      } else {
        emit(AuthError(response['message']?.toString() ?? 'Login failed'));
      }
    } catch (e, st) {
      emit(AuthError('Login failed: ${e.toString()}'));
    }
  }

  /// =========================
  /// Load tourist from storage
  /// =========================
  Future<void> _onLoadAuthFromStorage(
    LoadAuthFromStorage event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final tourist = await TokenStorage.getTourist();
      final token = await TokenStorage.getToken();

      if (tourist != null && token != null) {
        emit(AuthSuccess(tourist));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError("Failed to load stored auth: ${e.toString()}"));
    }
  }

  /// =========================
  /// Fetch tourist details explicitly
  /// =========================
  Future<void> _onGetTouristDetails(
    GetTouristDetailsEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final tourist = await getTouristDetails(event.touristId);
      emit(GetTouristDetailsSuccess(tourist));
    } catch (e) {
      emit(AuthError('Failed to load tourist details: ${e.toString()}'));
    }
  }

  /// =========================
  /// Logout
  /// =========================
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await TokenStorage.clear();
    print("logged out");
    emit(AuthInitial());
  }
}
