import 'dart:io';
import 'package:Travelon/features/auth/domain/entities/register_tourist.dart';

import '../repositories/tourist_repository.dart';

class RegisterTourist {
  final TouristRepository repository;

  RegisterTourist(this.repository);

  Future<Map<String, dynamic>> call(
    RegisterTouristEntity data,
    File kycFile,
  ) {
    return repository.registerTourist(data, kycFile);
  }
}
