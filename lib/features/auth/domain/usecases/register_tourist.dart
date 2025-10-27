import '../entities/tourist.dart';
import '../repositories/tourist_repository.dart';
import 'dart:io';

class RegisterTourist {
  final TouristRepository repository;

  RegisterTourist(this.repository);

  Future<Map<String, dynamic>> call(Tourist tourist, File kycFile) {
    return repository.registerTourist(tourist, kycFile);
  }
}
