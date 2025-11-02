import '../repositories/tourist_repository.dart';

class LoginTourist {
  final TouristRepository repository;

  LoginTourist(this.repository);

  Future<Map<String, dynamic>> call(String email, String password) {
    return repository.loginTourist(email, password);
  }
}
