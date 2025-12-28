import '../repositories/tourist_repository.dart';

class UpdateTourist {
  final TouristRepository repository;

  UpdateTourist(this.repository);

  Future<void> call(
    String touristId,
    Map<String, dynamic> data,
  ) async {
    await repository.updateTourist(touristId, data);
  }
}
