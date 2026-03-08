import 'package:Travelon/features/auth/domain/entities/register_tourist.dart';
import '../entities/tourist.dart';
import 'dart:io';

/// ---------------------------------------------------------------------------
/// TouristRepository
/// ---------------------------------------------------------------------------
/// Abstract contract defining all authentication and profile operations.
/// 
/// This interface resides in the Domain layer, allowing the application
/// to interact with user data without being coupled to a specific 
/// network or storage implementation.
/// ---------------------------------------------------------------------------
abstract class TouristRepository {
  
  /// -------------------------------------------------------------------------
  /// Creates a new tourist account.
  /// 
  /// Takes a [RegisterTouristEntity] for profile data and a [File] for 
  /// identity verification (KYC).
  /// -------------------------------------------------------------------------
  Future<Map<String, dynamic>> registerTourist(
    RegisterTouristEntity data,
    File kycFile,
  );

  /// -------------------------------------------------------------------------
  /// Authenticates a user using their email and password.
  /// -------------------------------------------------------------------------
  Future<Map<String, dynamic>> loginTourist(String email, String password);

  /// -------------------------------------------------------------------------
  /// Retrieves the full profile of a tourist by their unique [touristId].
  /// 
  /// Returns a pure [Tourist] entity.
  /// -------------------------------------------------------------------------
  Future<Tourist> getTouristById(String touristId);

  /// -------------------------------------------------------------------------
  /// Initiates the password recovery process for the given email address.
  /// -------------------------------------------------------------------------
  Future<void> forgotPassword(String email);

  /// -------------------------------------------------------------------------
  /// Updates the user's password after verifying the [oldPassword].
  /// -------------------------------------------------------------------------
  Future<void> changePassword({
    required String touristId,
    required String oldPassword,
    required String newPassword,
  });

  /// -------------------------------------------------------------------------
  /// Updates specific fields of a tourist's profile.
  /// 
  /// [data] contains the key-value pairs of the fields to be modified.
  /// -------------------------------------------------------------------------
  Future<void> updateTourist(
    String touristId,
    Map<String, dynamic> data,
  );
}