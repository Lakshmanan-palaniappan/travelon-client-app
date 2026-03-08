import 'package:Travelon/features/auth/domain/repositories/tourist_repository.dart';

/// ---------------------------------------------------------------------------
/// ForgotPassword
/// ---------------------------------------------------------------------------
/// A Use Case that handles the request for a password reset.
/// 
/// This class acts as a single-purpose command to initiate the recovery 
/// process, typically resulting in an OTP or reset link being sent to the 
/// user's registered email.
/// ---------------------------------------------------------------------------
class ForgotPassword {
  final TouristRepository repository;

  ForgotPassword(this.repository);

  /// -------------------------------------------------------------------------
  /// Executes the forgot password request.
  /// 
  /// Parameters:
  /// - [email]: The user's registered email address to receive the reset link.
  /// -------------------------------------------------------------------------
  Future<void> call(String email) async {
    // This calls the repository contract to handle the network request
    await repository.forgotPassword(email);
  }
}