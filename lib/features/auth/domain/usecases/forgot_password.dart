import 'package:Travelon/features/auth/domain/repositories/tourist_repository.dart';

class ForgotPassword {
  final TouristRepository repository;

  ForgotPassword(this.repository);

  Future<void> call(String email) async {
    await repository.forgotPassword(email);
  }
}
