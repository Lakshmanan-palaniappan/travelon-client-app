import 'package:Travelon/features/auth/domain/entities/tourist.dart';
import 'package:Travelon/features/auth/domain/repositories/tourist_repository.dart';

class GetTouristDetails {
  final TouristRepository repository;

  GetTouristDetails(this.repository);

  Future<Tourist> call(String touristId) async {
    return await repository.getTouristById(touristId);
  }
}