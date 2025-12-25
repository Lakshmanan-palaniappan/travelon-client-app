// features/auth/domain/usecases/change_password.dart
import 'package:Travelon/features/auth/domain/repositories/tourist_repository.dart';

class ChangePassword {
  final TouristRepository repository;

  ChangePassword(this.repository);

  Future<void> call({
    required String oldPassword,
    required String newPassword,
    required String touristId
  }) {
    return repository.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword, touristId: touristId,
    );
  }
}
