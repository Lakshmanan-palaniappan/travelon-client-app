import '../repositories/tourist_repository.dart';

/// ---------------------------------------------------------------------------
/// LoginTourist
/// ---------------------------------------------------------------------------
/// A Use Case that handles the primary authentication flow for a tourist.
/// 
/// This class acts as a single-purpose command to verify credentials and 
/// obtain an authentication token or user session data.
/// ---------------------------------------------------------------------------
class LoginTourist {
  final TouristRepository repository;

  LoginTourist(this.repository);

  /// -------------------------------------------------------------------------
  /// Executes the login request.
  /// 
  /// Parameters:
  /// - [email]: The user's registered identification.
  /// - [password]: The secure credential provided by the user.
  /// 
  /// Returns a [Map] containing session metadata (e.g., JWT, Refresh Token).
  /// -------------------------------------------------------------------------
  Future<Map<String, dynamic>> call(String email, String password) {
    // Delegates the credential verification to the repository contract
    return repository.loginTourist(email, password);
  }
}