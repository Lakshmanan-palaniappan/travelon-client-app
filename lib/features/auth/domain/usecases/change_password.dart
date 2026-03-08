import 'package:Travelon/features/auth/domain/repositories/tourist_repository.dart';

/// ---------------------------------------------------------------------------
/// ChangePassword
/// ---------------------------------------------------------------------------
/// A Use Case that handles the business logic for updating a user's password.
/// 
/// This class acts as a bridge between the Presentation layer (UI/BLoC) 
/// and the Data layer (Repository), ensuring the security update is 
/// executed correctly.
/// ---------------------------------------------------------------------------
class ChangePassword {
  final TouristRepository repository;

  ChangePassword(this.repository);

  /// -------------------------------------------------------------------------
  /// Executes the change password command.
  /// 
  /// Parameters:
  /// - [oldPassword]: The current password for verification.
  /// - [newPassword]: The new desired password.
  /// - [touristId]: The unique identifier for the user.
  /// -------------------------------------------------------------------------
  Future<void> call({
    required String oldPassword,
    required String newPassword,
    required String touristId
  }) {
    return repository.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword, 
      touristId: touristId,
    );
  }
}