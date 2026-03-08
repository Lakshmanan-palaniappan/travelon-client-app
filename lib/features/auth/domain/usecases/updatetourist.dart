import '../repositories/tourist_repository.dart';

/// ---------------------------------------------------------------------------
/// UpdateTourist
/// ---------------------------------------------------------------------------
/// A Use Case that handles the business logic for modifying a tourist's profile.
/// 
/// This class acts as a single-purpose command to synchronize local profile 
/// changes with the remote server for a specific [touristId].
class UpdateTourist {
  final TouristRepository repository;

  UpdateTourist(this.repository);

  /// -------------------------------------------------------------------------
  /// Executes the update command.
  /// 
  /// Parameters:
  /// - [touristId]: The unique identifier of the user being updated.
  /// - [data]: A [Map] containing only the key-value pairs that need 
  ///   to be changed (e.g., {"address": "New City", "contact": "9876543210"}).
  /// -------------------------------------------------------------------------
  Future<void> call(
    String touristId,
    Map<String, dynamic> data,
  ) async {
    // Delegates the partial update to the repository contract
    await repository.updateTourist(touristId, data);
  }
}