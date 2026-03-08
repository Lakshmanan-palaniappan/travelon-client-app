import 'package:Travelon/features/auth/domain/entities/tourist.dart';
import 'package:Travelon/features/auth/domain/repositories/tourist_repository.dart';

/// ---------------------------------------------------------------------------
/// GetTouristDetails
/// ---------------------------------------------------------------------------
/// A Use Case responsible for retrieving a complete [Tourist] profile.
/// 
/// This class acts as the single source of truth for fetching user data 
/// throughout the application.
/// ---------------------------------------------------------------------------
class GetTouristDetails {
  final TouristRepository repository;

  GetTouristDetails(this.repository);

  /// -------------------------------------------------------------------------
  /// Executes the retrieval request.
  /// 
  /// Returns a [Future] containing the [Tourist] entity associated 
  /// with the provided [touristId].
  /// -------------------------------------------------------------------------
  Future<Tourist> call(String touristId) async {
    // Delegates the data fetch to the repository contract
    return await repository.getTouristById(touristId);
  }
}