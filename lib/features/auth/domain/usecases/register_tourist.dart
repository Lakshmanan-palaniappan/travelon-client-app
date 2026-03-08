import 'dart:io';
import 'package:Travelon/features/auth/domain/entities/register_tourist.dart';
import '../repositories/tourist_repository.dart';

/// ---------------------------------------------------------------------------
/// RegisterTourist
/// ---------------------------------------------------------------------------
/// A Use Case that handles the business logic for creating a new user account.
/// 
/// This class acts as a single-purpose command to process a tourist's 
/// registration, requiring both their profile information and a 
/// physical identity document (KYC) for verification.
/// ---------------------------------------------------------------------------
class RegisterTourist {
  final TouristRepository repository;

  RegisterTourist(this.repository);

  /// -------------------------------------------------------------------------
  /// Executes the registration command.
  /// 
  /// Parameters:
  /// - [data]: A [RegisterTouristEntity] containing validated user details.
  /// - [kycFile]: A [File] object representing the user's uploaded identity proof.
  /// 
  /// Returns a [Map] containing the server response (e.g., success message, 
  /// initial token, or account status).
  /// -------------------------------------------------------------------------
  Future<Map<String, dynamic>> call(
    RegisterTouristEntity data,
    File kycFile,
  ) {
    // Delegates the multi-part registration to the repository contract
    return repository.registerTourist(data, kycFile);
  }
}